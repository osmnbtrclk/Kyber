// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <EASTL/map.h>
#include <EASTL/string.h>

namespace Kyber
{
class Sentry
{
public:
    static void Initialize();

    typedef eastl::map<eastl::string, eastl::string> DebugContextData;
    static DebugContextData s_debugContextData;
};
} // namespace Kyber