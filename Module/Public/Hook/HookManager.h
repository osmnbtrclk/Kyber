// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.
// Adapted from ReShade.

#pragma once

#include <Hook/Hook.h>

#include <Windows.h>

namespace Kyber
{
class HookManager
{
public:
    static void CreateHook(Hook::Address target, LPVOID replacement);
    static void DisableHook(Hook::Address target);
    static void EnableHook(Hook::Address target);
    static void RemoveHook(Hook::Address target);
    static void RemoveHooks();
    static Hook::Address Call(Hook::Address replacement, Hook::Address target);
    template<typename T>
    static inline T Call(T replacement, Hook::Address target = nullptr)
    {
        return reinterpret_cast<T>(Call(reinterpret_cast<Hook::Address>(replacement), target));
    }
};
} // namespace Kyber