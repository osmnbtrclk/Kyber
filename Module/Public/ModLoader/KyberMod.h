// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Network/SocketManager.h>
#include <SDK/TypeInfo.h>

#include <frosty_mod.h>

namespace Kyber
{
struct ModResourceData
{
    size_t size;
    size_t originalSize;
    
    void* buffer;

    int32_t fbFile;
    uint32_t dataOffset;

    // Res Data
    uint32_t resType;
    uint64_t resRid;
    uint8_t resMeta[0x10];

    // Chunk Data
    uint32_t rangeStart;
    uint32_t rangeEnd;
    uint32_t logicalOffset;
    uint32_t logicalSize;
    int32_t h32;
    int32_t firstMip;
};

struct KyberHandledModResource
{
    int32_t handlerHash;
    bool dupedWithHandler;
};

struct ModResource
{
    RTFrostyResourceTypeE type;
    eastl::string name;
    eastl::vector<uint32_t> bundles;

    int32_t handlerHash;
    int32_t resourceIndex;
    bool dupedWithHandler;

    eastl::string modName;
    uint32_t modIndex;

    ModResourceData data;

    uint32_t uniqueIdWithType;

    bool ContainsBundle(uint32_t hash) const
    {
        return eastl::count(bundles.begin(), bundles.end(), hash);
    }

    eastl::string GetNameWithType() const
    {
        return eastl::string(std::to_string(type).c_str()) + "_" + name;
    }

    eastl::string GetNameWithMod() const
    {
        return eastl::string(std::to_string(modIndex).c_str()) + "_" + name;
    }
};

struct KyberMod
{
    eastl::string path;
    int32_t fbFile;

    std::vector<ModResource> resources;
};
} // namespace Kyber
