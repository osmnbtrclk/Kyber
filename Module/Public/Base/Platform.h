// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

namespace Kyber
{
#if defined(_DEBUG)
    #define KYBER_BUILD_CHANNEL_NAME "Debug"
#else
    #define KYBER_BUILD_CHANNEL_NAME "Release"
#endif

enum class BuildChannel
{
    Debug,
    Release,

#if defined(_DEBUG)
    Current = Debug
#else
    Current = Release
#endif
};
} // namespace Kyber
