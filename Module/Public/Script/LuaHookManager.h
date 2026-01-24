// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Script/Lua.h>
#include <Hook/HookManager.h>

#include <functional>
#include <map>
#include <string>

namespace Kyber
{
typedef std::function<int(lua_State*)> LuaHookCallbackParamSetupFunc;
typedef std::function<int(lua_State*)> LuaHookCallbackContextCallFunc;
typedef std::function<void(lua_State*)> LuaHookCallbackParamCleanupFunc;

typedef std::function<void(LuaHookCallbackParamSetupFunc, LuaHookCallbackParamCleanupFunc)> LuaHookCallback;

class LuaHookManager
{
public:
    LuaHookManager(lua_State* L);

    void Hook(const std::string& eventName, LuaHookCallback callback);

    template<typename R, typename T, typename... Args>
    R Fire(const std::string& eventName, T hookedFunc, Args... args)
    {
        for (const auto& callback : m_hooks[eventName])
        {
            KB_LUA_LOCK;

            R result;
            callback(
                [args...](lua_State* L) {
                    (LuaUtils::Push(L, args), ...);
                    return static_cast<int>(sizeof...(args));
                },
                [hookedFunc, args...](lua_State* L) {
                    const auto trampoline = HookManager::Call(hookedFunc);
                    // Pop all the args from the stack and call the hooked function
                    std::tuple<Args...> arguments;
                    LuaUtils::PopTuple(L, arguments);
                    auto result = trampoline(arguments);
                },
                [&result, args...](lua_State* L) { result = LuaUtils::Pop(L); });
            return result;
        }
    }

private:
    std::map<std::string, std::vector<LuaHookCallback>> m_hooks;
};
} // namespace Kyber