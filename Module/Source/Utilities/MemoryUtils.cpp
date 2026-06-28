// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Utilities/MemoryUtils.h>
#include <Core/Memory.h>

#include <Windows.h>

namespace Kyber
{
void MemoryUtils::Patch(void* dst, void* src, unsigned int size)
{
    DWORD oldprotect;
    VirtualProtect(dst, size, PAGE_EXECUTE_READWRITE, &oldprotect);
    memcpy(dst, src, size);
    VirtualProtect(dst, size, oldprotect, &oldprotect);
}

void MemoryUtils::Nop(void* dst, unsigned int size)
{
    DWORD oldprotect;
    VirtualProtect(dst, size, PAGE_EXECUTE_READWRITE, &oldprotect);
    memset(dst, 0x90, size);
    VirtualProtect(dst, size, oldprotect, &oldprotect);
}
} // namespace Kyber
