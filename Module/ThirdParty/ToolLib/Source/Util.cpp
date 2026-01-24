#include <ToolLib/Util.h>

#include <Windows.h>

void tlInvokeCrash(const std::string& reason)
{
    LPCSTR base = "Something went wrong, please read the message below and try again.\n\nException Details:\n";
    std::string combined = std::string(base) + reason;
    LPCSTR combinedLPC = combined.c_str();

    MessageBox(0, combinedLPC, "ERROR", MB_ICONERROR);
    ExitProcess(EXIT_FAILURE);
}

void tlSetBytes(void* dst, int32_t val, uint32_t size)
{
    DWORD oldprotect;
    VirtualProtect(dst, size, PAGE_EXECUTE_READWRITE, &oldprotect);
    memset(dst, val, size);
    VirtualProtect(dst, size, oldprotect, &oldprotect);
}

void tlCopyBytes(void* dst, void* src, uint32_t size)
{
    DWORD oldprotect;
    VirtualProtect(dst, size, PAGE_EXECUTE_READWRITE, &oldprotect);
    memcpy(dst, src, size);
    VirtualProtect(dst, size, oldprotect, &oldprotect);
}

void tlNopBytes(void* dst, uint32_t size)
{
    DWORD oldprotect;
    VirtualProtect(dst, size, PAGE_EXECUTE_READWRITE, &oldprotect);
    memset(dst, 0x90, size);
    VirtualProtect(dst, size, oldprotect, &oldprotect);
}