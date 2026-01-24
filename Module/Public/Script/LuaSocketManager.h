// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Script/Lua.h>

#include <SDK/SDK.h>

#include <basetsd.h>

namespace Kyber
{
class LuaSocketManager
{
public:
    static UINT_PTR GetSocket(lua_State* L, int index);
    static const UINT_PTR* WrapSocket(lua_State* L, const UINT_PTR socket);

    static void Register(lua_State* L);
};
} // namespace Kyber
