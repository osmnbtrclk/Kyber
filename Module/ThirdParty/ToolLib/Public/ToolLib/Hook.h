// Adapted from ReShade.

#pragma once

#include <Windows.h>

#define HOOK_OFFSET(addr) reinterpret_cast<void*>(addr)

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

    static bool applyQueuedActions();

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

    void enable() const;
    void disable() const;

    Hook::Status install();
    Hook::Status uninstall();

    Address call() const;
    template<typename T>
    T call() const
    {
        return reinterpret_cast<T>(call());
    }

    Address target = nullptr;
    Address trampoline = nullptr;
    LPVOID replacement = nullptr;
};
