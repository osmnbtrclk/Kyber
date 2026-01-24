// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.
// Adapted from ReShade.

#pragma once

#include <Windows.h>

#include <safetyhook.hpp>

#include <optional>

namespace Kyber
{
#ifndef HOOK_OFFSET
#define HOOK_OFFSET(addr) reinterpret_cast<void*>(addr)
#endif

struct HookTemplate
{
    void* offset;
    void* hook;
};

class Hook
{
public:
    using Address = void*;

    enum class Status
    {
        unknown = -1,
        success,
        not_executable = 7,
        unsupported_function,
        allocation_failure,
        memory_protection_failure,
    };

    static bool ApplyQueuedActions();

    bool valid() const
    {
        return target != nullptr && replacement != nullptr && target != replacement;
    }

    bool installed() const
    {
        return trampoline != nullptr;
    }
    bool uninstalled() const
    {
        return trampoline == nullptr;
    }

    Hook::Status install();
    Hook::Status uninstall();

    Address Call() const;
    template<typename T>
    T Call() const
    {
        return reinterpret_cast<T>(Call());
    }

    std::optional<safetyhook::InlineHook> m_hook;

    Address target = nullptr;
    Address trampoline = nullptr;
    LPVOID replacement = nullptr;
};
} // namespace Kyber