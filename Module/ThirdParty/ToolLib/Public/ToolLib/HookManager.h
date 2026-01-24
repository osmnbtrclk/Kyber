// Adapted from ReShade.

#pragma once

#include "Hook.h"

#include <Windows.h>

class HookManager
{
public:
    static void createHook(Hook::Address target, LPVOID replacement);
    static void disableHook(Hook::Address target);
    static void enableHook(Hook::Address target);
    static void removeHook(Hook::Address target);
    static void removeHooks();
    static Hook::Address call(Hook::Address replacement, Hook::Address target);
    template<typename T>
    static inline T call(T replacement, Hook::Address target = nullptr)
    {
        return reinterpret_cast<T>(call(reinterpret_cast<Hook::Address>(replacement), target));
    }
};
