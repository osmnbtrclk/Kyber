// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Script/Lua.h>

#include <functional>
#include <map>
#include <string>

namespace Kyber::Script
{
void RegisterGlobals(lua_State* L);
} // namespace Kyber
