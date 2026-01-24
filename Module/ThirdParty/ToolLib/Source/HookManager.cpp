// Adapted from ReShade.

#include <ToolLib/HookManager.h>

#include <cassert>
#include <vector>
#include <mutex>

std::vector<Hook> hooks;
std::mutex hooksMutex;

enum class HookMethod
{
    export_hook,
    function_hook,
    vtable_hook
};

struct NamedHook : public Hook
{
    const char* name;
    HookMethod method;
};

void HookManager::createHook(Hook::Address target, LPVOID replacement)
{
    Hook hook;
    hook.target = target;
    hook.trampoline = target;
    hook.replacement = replacement;
    hook.install();
    hooks.push_back(hook);
}

void HookManager::enableHook(Hook::Address target)
{
    for (auto& hook : hooks)
    {
        if (hook.target == target)
        {
            hook.enable();
            return;
        }
    }
}

void HookManager::disableHook(Hook::Address target)
{
    for (auto& hook : hooks)
    {
        if (hook.target == target)
        {
            hook.disable();
            return;
        }
    }
}

void HookManager::removeHook(Hook::Address target)
{
    for (auto it = hooks.begin(); it != hooks.end(); ++it)
    {
        if (it->target == target)
        {
            it->uninstall();
            hooks.erase(it);
            return;
        }
    }
}

void HookManager::removeHooks()
{
    for (auto& hook : hooks)
    {
        hook.uninstall();
    }
    hooks.clear();
}

Hook::Address HookManager::call(LPVOID replacement, Hook::Address target)
{
    assert(target != nullptr || replacement != nullptr);

    for (int attempt = 0; attempt < 2; ++attempt)
    {
        // Protect access to hook list with a mutex
        const std::lock_guard<std::mutex> lock(hooksMutex);

        // Enumerate list of installed hooks and find matching one
        const auto it = std::find_if(hooks.cbegin(), hooks.cend(), [target, replacement](const Hook& hook) {
            // If only a target Address is provided, find the matching hook
            if (replacement == nullptr)
                return hook.target == target;
            // Otherwise search with the replacement function Address (since the target Address may not be known inside
            // a replacement function)
            return hook.replacement == replacement &&
                   // Optionally compare the target Address too, in case the replacement function is used to hook
                   // multiple targets (do not do this if it is unknown)
                   (target == nullptr || hook.target == target);
        });

        const Hook tempHook = it != hooks.cend() ? *it : Hook{};

        if (tempHook.valid())
            return tempHook.call();
    }

    return nullptr;
}
