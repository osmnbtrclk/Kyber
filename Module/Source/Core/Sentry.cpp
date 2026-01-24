// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Core/Sentry.h>

#include <Base/Log.h>
#include <Hook/HookManager.h>
#include <Utilities/PlatformUtils.h>

#include <sentry.h>

#include <errhandlingapi.h>

namespace Kyber
{
Sentry::DebugContextData Sentry::s_debugContextData;

class MiniDumpInfo
{
public:
    char pad_0000[16]; // 0x0000
    EXCEPTION_POINTERS* exceptionInfo;
};

void WriteMiniDumpHk(MiniDumpInfo* params)
{
    static const auto trampoline = HookManager::Call(WriteMiniDumpHk);

    KYBER_LOG(Info, "Redirecting crash to Sentry");

    for (const auto& [key, value] : Sentry::s_debugContextData)
    {
        if (key == "ModuleInfo" || key == "MachineUniqueId")
        {
            continue;
        }

        eastl::string sanitizedValue = value.substr(0, 200);
        sanitizedValue.erase(eastl::remove(sanitizedValue.begin(), sanitizedValue.end(), '\n'), sanitizedValue.end());
        sentry_set_tag(key.c_str(), sanitizedValue.c_str());
    }

    sentry_ucontext_t uctx;
    memset(&uctx, 0, sizeof(uctx));
    uctx.exception_ptrs = *params->exceptionInfo;
    sentry_handle_exception(&uctx);
    
    if (PlatformUtils::GetEnv("KYBER_PRESERVE_CRASH_DUMP", "0") == "1")
    {
        trampoline(params);
    }
}

static sentry_value_t OnCrash(const sentry_ucontext_t* uctx, sentry_value_t event, void* closure)
{
    KYBER_LOG(Info, "Crash detected, uploading");
    sentry_uuid_t uuid = sentry_capture_event(event);

    char buf[37];
    sentry_uuid_as_string(&uuid, buf);

    KYBER_LOG(Info, "Crash uploaded " << buf);
    return sentry_value_new_null();
}

void Sentry::Initialize()
{
#if defined(_DEBUG)
    KYBER_LOG(Info, "Sentry disabled in debug builds");
    return;
#endif

    sentry_options_t* options = sentry_options_new();
    sentry_options_set_dsn(options, "https://3be50e0a7bc8258a06f413c6fdef0521@sentry.kyber.gg/2");

    sentry_options_set_database_pathw(options, (PlatformUtils::GetProgramDataPath() / "ModuleData/Sentry").c_str());

    std::string moduleVersion = PlatformUtils::GetEnv("KYBER_MODULE_VERSION", "unknown");
    sentry_options_set_release(options, ("kyber-module@" + moduleVersion).c_str());
    sentry_options_set_debug(options, PlatformUtils::GetEnv("KYBER_SENTRY_DEBUG", "0") == "1");
    sentry_options_set_sample_rate(options, 1.0);
    
    sentry_init(options);

    sentry_value_t user = sentry_value_new_object();
    sentry_value_set_by_key(user, "id", sentry_value_new_string(PlatformUtils::GetEnv("EASecureLaunchTokenTemp", "unknown").c_str()));
    sentry_value_set_by_key(user, "username", sentry_value_new_string(PlatformUtils::GetEnv("EALaunchEAID", "unknown").c_str()));
    sentry_set_user(user);

    sentry_options_set_on_crash(options, OnCrash, nullptr);

    HookManager::CreateHook(HOOK_OFFSET(0x1401FFC30), WriteMiniDumpHk);
    Hook::ApplyQueuedActions();

    KYBER_LOG(Info, "Sentry initialized");
}
} // namespace Kyber
