// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include "util.h"
#include "array.h"
#include "frosty_resource.h"

#include <stdint.h>
#include <stdio.h>

typedef struct
{
    char* title;
    char* author;
    char* category;
    char* version;
    char* description;
    char* link;
} FrostyModDetailsT;

typedef struct
{
    uint64_t magic;
    uint32_t version;

    int64_t dataOffset;
    int32_t dataCount;
    int32_t gameVersion;

    char* profile;

    FrostyModDetailsT details;
    RTArrayT* resources;

    FILE* fp;
} RTFrostyModT;

EXTERN_C_BLOCK_START

// Load a Frosty mod from memory. Takes ownership of the file descriptor.
RTErrorT RT_FrostyLoadMod(FILE* fp, RTFrostyModT** outMod);

// Read data out of a mod resource
RTErrorT RT_FrostyReadModResource(RTFrostyModT* mod, RTFrostyResourceT* resource, char** outBuf, size_t* outSize);

// Destroy a loaded Frosty mod.
void RT_FrostyDestroyMod(RTFrostyModT* mod);

EXTERN_C_BLOCK_END