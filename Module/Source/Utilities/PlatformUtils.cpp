// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Utilities/PlatformUtils.h>
#include <Utilities/StringUtils.h>

#include <ToolLib/Func.h>
#include <Base/Log.h>

#include <cstdlib>
#include <filesystem>
#include <libloaderapi.h>
#include <processthreadsapi.h>
#include <psapi.h>
#include <string>

namespace Kyber
{
std::filesystem::path PlatformUtils::GetModulePath()
{
    char path[MAX_PATH];
    HMODULE hm = NULL;

    if ((hm = GetModuleHandle("Kyber.dll")) == 0)
    {
        int ret = GetLastError();
        KYBER_LOG(Error, "GetModuleHandle failed, error = " << ret);
        return std::filesystem::path();
    }

    if (GetModuleFileName(hm, path, sizeof(path)) == 0)
    {
        int ret = GetLastError();
        KYBER_LOG(Error, "GetModuleFileName failed, error = " << ret);
        return std::filesystem::path();
    }

    return std::filesystem::path(path).remove_filename();
}

std::filesystem::path PlatformUtils::GetProgramDataPath()
{
    std::filesystem::path appdata = std::getenv("APPDATA");
    return appdata / "ArmchairDevelopers/Kyber";
}

std::string PlatformUtils::GetEnv(const std::string& env, const std::string& def)
{
    const char* result = std::getenv(env.c_str());
    if (result == nullptr)
    {
        return def;
    }

    return result;
}

BOOL PlatformUtils::MaskCompare(PVOID pBuffer, LPCSTR lpPattern, LPCSTR lpMask)
{
    for (auto value = static_cast<PBYTE>(pBuffer); *lpMask; ++lpPattern, ++lpMask, ++value)
    {
        if (*lpMask == 'x' && *reinterpret_cast<LPCBYTE>(lpPattern) != *value)
            return false;
    }

    return true;
}

uintptr_t PlatformUtils::BaseAddress()
{
    return reinterpret_cast<uintptr_t>(GetModuleHandle(0));
}

void* PlatformUtils::GetVTableFunction(const void* pVtable, int offset)
{
    intptr_t vtable = *((intptr_t*)pVtable);
    intptr_t func = vtable + sizeof(intptr_t) * offset;
    return reinterpret_cast<void*>(*((intptr_t*)func));
}

void* PlatformUtils::HookVTableFunction(void* pVtable, void* fnHookFunc, int offset)
{
    intptr_t vtable = *((intptr_t*)pVtable);
    intptr_t func = vtable + sizeof(intptr_t) * offset;
    intptr_t orig = *((intptr_t*)func);

    MEMORY_BASIC_INFORMATION mbi;
    VirtualQuery((LPCVOID)func, &mbi, sizeof(mbi));
    VirtualProtect(mbi.BaseAddress, mbi.RegionSize, PAGE_EXECUTE_READWRITE, &mbi.Protect);

    *((intptr_t*)func) = (intptr_t)fnHookFunc;

    VirtualProtect(mbi.BaseAddress, mbi.RegionSize, mbi.Protect, &mbi.Protect);

    return reinterpret_cast<void*>(orig);
}

void* PlatformUtils::DuplicateVTable(void* objectPtr, size_t numVirtualFunctions)
{
    void** originalVTable = *reinterpret_cast<void***>(objectPtr);
    size_t vtableSize = sizeof(void*) * numVirtualFunctions;
    void** newVTable = new void*[numVirtualFunctions];
    std::memcpy(newVTable, originalVTable, vtableSize);
    *reinterpret_cast<void***>(objectPtr) = newVTable;
    return newVTable;
}
} // namespace Kyber
