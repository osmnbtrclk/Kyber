#include <ToolLib/Renderer.h>

#include <ToolLib/HookManager.h>
#include <ToolLib/Log.h>
#include <ToolLib/Util.h>

#include <backends/imgui_impl_dx11.h>
#include <backends/imgui_impl_win32.h>
#include <d3d11.h>
#include <imgui.h>
#include <imgui_internal.h>
#include <MinHook.h>

#include <typeinfo>
#include <Windows.h>
#include <winerror.h>
#include <winuser.h>

#pragma comment(lib, "d3d11.lib")

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

Renderer* g_renderer = nullptr;

WNDPROC lpPrevWndFunc;
static HWND hWnd = 0;

LRESULT CALLBACK hkWndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    static const auto trampoline = HookManager::call(hkWndProc);
    ImGuiIO& io = ImGui::GetIO();

    if (g_renderer == nullptr)
    {
        TL_INFO("Renderer is null in WndProc");
        return 0;
    }

    if (g_renderer->canPresent() && ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam))
    {
        return true;
    }

    switch (msg)
    {
    case WM_SYSCOMMAND:
        if ((wParam & 0xfff0) == SC_KEYMENU) // Disable ALT application menu
            return 0;
        break;
    }

    return trampoline(hWnd, msg, wParam, lParam);
}

HRESULT hkPresent(IDXGISwapChain* pInstance, UINT syncInterval, UINT flags)
{
    static const auto trampoline = HookManager::call(hkPresent);

    // Poll and handle messages (inputs, window resize, etc)
    static MSG msg;
    ZeroMemory(&msg, sizeof(msg));
    if (::PeekMessage(&msg, hWnd, 0U, 0U, PM_REMOVE))
    {
        ::TranslateMessage(&msg);
        ::DispatchMessage(&msg);
    }

    if (g_renderer == nullptr)
    {
        TL_ERROR("Renderer is null?");
        return 0;
    }

    if (!g_renderer->canPresent())
    {
        g_renderer->initDevice(pInstance);
    }

    g_renderer->beginFrame();
    g_renderer->endFrame();

    return trampoline(pInstance, syncInterval, flags);
}

HRESULT hkResizeBuffers(IDXGISwapChain* pInstance, UINT BufferCount, UINT Width, UINT Height, DXGI_FORMAT NewFormat, UINT SwapChainFlags)
{
    return g_renderer->resizeBuffers(pInstance, BufferCount, Width, Height, NewFormat, SwapChainFlags);
}

Renderer::Renderer(const char* windowClass, const char* windowTitle)
{
    g_renderer = this;

    TL_INFO("Initializing renderer");

    IDXGISwapChain* swapChain;
    ID3D11Device* device;
    ID3D11DeviceContext* context;

    auto featureLevel = D3D_FEATURE_LEVEL_11_0;

    DXGI_SWAP_CHAIN_DESC desc = {};

    desc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    desc.BufferCount = 1;

    TL_INFO("Attempting to find window");

    hWnd = FindWindow(windowClass, windowTitle);

    if (!hWnd)
    {
        tlInvokeCrash("Failed to find window.");
    }

    desc.OutputWindow = hWnd;
    desc.Windowed = true;

    desc.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;

    if (FAILED(D3D11CreateDeviceAndSwapChain(nullptr, D3D_DRIVER_TYPE_HARDWARE, 0, 0, &featureLevel, 1, D3D11_SDK_VERSION, &desc,
                                             &swapChain, &device, nullptr, &context)))
    {
        tlInvokeCrash("Failed to create device and swap chain.");
    }

    auto vtable = *reinterpret_cast<PVOID**>(swapChain);
    auto present = vtable[8];
    auto resizeBuffers = vtable[13];

    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;

    swapChain->Release();
    device->Release();
    context->Release();

    HookManager::createHook(present, hkPresent);
    HookManager::createHook(resizeBuffers, hkResizeBuffers);
    HookManager::createHook(HOOK_OFFSET((IsWindowUnicode(hWnd) ? GetWindowLongPtrW : GetWindowLongPtrA)(hWnd, GWLP_WNDPROC)), hkWndProc);
    Hook::applyQueuedActions();

    TL_INFO("Renderer enabled");
}

Renderer::~Renderer() {}

void Renderer::initDevice(IDXGISwapChain* swapChain)
{
    TL_INFO("Initializing rendering device");

    swapChain->GetDevice(__uuidof(m_currentDevice), reinterpret_cast<PVOID*>(&m_currentDevice));

    m_currentDevice->GetImmediateContext(&m_currentContext);

    ID3D11Texture2D* target = nullptr;
    swapChain->GetBuffer(0, __uuidof(target), reinterpret_cast<PVOID*>(&target));

    m_currentDevice->CreateRenderTargetView(target, nullptr, &m_currentView);

    target->Release();

    ID3D11Texture2D* pBuffer = nullptr;
    swapChain->GetBuffer(0, __uuidof(ID3D11Texture2D), reinterpret_cast<PVOID*>(&pBuffer));

    D3D11_TEXTURE2D_DESC desc = {};
    pBuffer->GetDesc(&desc);

    pBuffer->Release();

    ImGuiIO& io = ImGui::GetIO();

    if (io.BackendPlatformUserData == NULL && !ImGui_ImplWin32_Init(hWnd))
    {
        tlInvokeCrash("ImGui_ImplWIn32_Init Failed.");
    }

    if (io.BackendRendererUserData == NULL && !ImGui_ImplDX11_Init(m_currentDevice, m_currentContext))
    {
        tlInvokeCrash("ImGui_ImplDX11_Init Failed.");
    }

    if (!ImGui_ImplDX11_CreateDeviceObjects())
    {
        tlInvokeCrash("ImGui_ImplDX11_CreateDeviceObjects Failed.");
    }

    TL_INFO("Success");
}

void Renderer::beginFrame()
{
    ImGui_ImplDX11_NewFrame();
    ImGui_ImplWin32_NewFrame();
    ImGui::NewFrame();
}

void Renderer::endFrame()
{
    ImGui::Render();

    m_currentContext->OMSetRenderTargets(1, &m_currentView, NULL);

    ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
}

HRESULT Renderer::resizeBuffers(IDXGISwapChain* instance, UINT bufferCount, UINT width, UINT height, DXGI_FORMAT newFormat,
                                UINT swapChainFlags)
{
    static const auto trampoline = HookManager::call(hkResizeBuffers);

    if (ImGui::GetIO().BackendRendererUserData != NULL)
    {
        ImGui_ImplDX11_Shutdown();

        g_renderer->getCurrentView()->Release();
        g_renderer->getCurrentContext()->Release();
        g_renderer->getCurrentDevice()->Release();

        g_renderer->setCurrentDevice(nullptr);
    }

    return trampoline(instance, bufferCount, width, height, newFormat, swapChainFlags);
}
