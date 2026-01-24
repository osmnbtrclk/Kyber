// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <ToolLib/Func.h>

#include <cstdint>

namespace Kyber
{
enum FrameType : uint32_t
{
    FrameType_Main = 1,
    FrameType_Game,
    FrameType_ClientSim,
    FrameType_ServerSim,
    FrameType_Render,
    FrameType_Audio,
    FrameType_Input,
    FrameType_FrontEnd,
    FrameType__Count,
    FrameType_Unknown = 0
};

struct FrameInfo
{
    union
    {
        struct
        {
            FrameType type;
            uint32_t index;
        };
        uintptr_t data;
    };
};

TL_DECLARE_FUNC(0x1401FD460, FrameInfo, Frame_getCurrent);
} // namespace Kyber
