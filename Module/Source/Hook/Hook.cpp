// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.
// Adapted from ReShade.

#include <Hook/Hook.h>

#include <MinHook.h>
#include <safetyhook.hpp>

#include <Base/Log.h>

#include <cassert>

namespace Kyber
{
// Verify status codes match the ones from MinHook
static_assert(static_cast<int>(Hook::Status::unknown) == MH_UNKNOWN);
static_assert(static_cast<int>(Hook::Status::success) == MH_OK);
static_assert(static_cast<int>(Hook::Status::not_executable) == MH_ERROR_NOT_EXECUTABLE);
static_assert(static_cast<int>(Hook::Status::unsupported_function) == MH_ERROR_UNSUPPORTED_FUNCTION);
static_assert(static_cast<int>(Hook::Status::allocation_failure) == MH_ERROR_MEMORY_ALLOC);
static_assert(static_cast<int>(Hook::Status::memory_protection_failure) == MH_ERROR_MEMORY_PROTECT);

static unsigned long s_reference_count = 0;

SafetyHookInline g_hook; // Global instance for managing hooks

Hook::Status Hook::install()
{
    if (!valid())
    {
        KYBER_LOG(Error, "Hook attempted on invalid function");
        return Hook::Status::unsupported_function;
    }

    m_hook = safetyhook::create_inline(target, replacement);
    trampoline = m_hook->trampoline().data();

    return Hook::Status::success;
}

Hook::Status Hook::uninstall()
{
    m_hook.reset();
    return Hook::Status::success;
}

Hook::Address Hook::Call() const
{
    assert(installed());

    return trampoline;
}

bool Hook::ApplyQueuedActions()
{
    return true;
    bool success = MH_ApplyQueued() == MH_OK;
    if (!success)
    {
        KYBER_LOG(Error, "Failed to apply queued hooks");
    }
    return success;
}
} // namespace Kyber