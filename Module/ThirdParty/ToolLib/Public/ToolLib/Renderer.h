#pragma once

#include <d3d11.h>
#include <dxgi1_2.h>

class Renderer
{
public:
    Renderer(const char* windowClass, const char* windowTitle = nullptr);
    ~Renderer();

    void initDevice(IDXGISwapChain* swapChain);

    virtual void beginFrame();
    virtual void endFrame();

    virtual HRESULT resizeBuffers(IDXGISwapChain* instance, UINT bufferCount, UINT width, UINT height, DXGI_FORMAT newFormat,
                               UINT swapChainFlags);

    IDXGISwapChain1* getSwapChain() const { return m_swapChain; }
    ID3D11Device* getCurrentDevice() const { return m_currentDevice; }
    ID3D11DeviceContext* getCurrentContext() const { return m_currentContext; }
    ID3D11RenderTargetView* getCurrentView() const { return m_currentView; }

    void setCurrentDevice(ID3D11Device* device) { m_currentDevice = device; }
    void setCurrentContext(ID3D11DeviceContext* context) { m_currentContext = context; }
    void setCurrentView(ID3D11RenderTargetView* view) { m_currentView = view; }

    bool canPresent() const { return m_currentDevice != nullptr; }

protected:
    IDXGISwapChain1* m_swapChain = nullptr;
    ID3D11Device* m_currentDevice = nullptr;
    ID3D11DeviceContext* m_currentContext = nullptr;
    ID3D11RenderTargetView* m_currentView = nullptr;

    bool m_initialized = false;
    bool m_shouldInitialize = false;
};

extern Renderer* g_renderer;