// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include "frosty_mod.h"

#include "parse_common.h"

#include <stdlib.h>
#include <string.h>

const uint64_t kFrostyMagic = 0x01005954534F5246;

const uint64_t kFrostyLowestVersion = 1;
const uint64_t kFrostyHighestVersion = 5;

RTErrorT _ParseModHeader(FILE* fp, RTFrostyModT* mod)
{
    // Read magic values & data header
    RT_READ_FP(mod->magic, uint64_t, fp);
    RT_READ_FP(mod->version, uint32_t, fp);

    if (mod->magic != kFrostyMagic || mod->version < kFrostyLowestVersion || mod->version > kFrostyHighestVersion)
    {
        return RT_ERROR_INVALID_MOD_HEADER;
    }

    RT_READ_FP(mod->dataOffset, int64_t, fp);
    RT_READ_FP(mod->dataCount, int32_t, fp);

    // Read profile string
    RT_SAFE_RET(RT_ReadSizedString(fp, &mod->profile));

    // Read game version
    RT_READ_FP(mod->gameVersion, int32_t, fp);

    return RT_SUCCESS;
}

RTErrorT _ParseModDetails(FILE* fp, FrostyModDetailsT* details, uint32_t version)
{
    RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->title));
    RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->author));
    RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->category));
    RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->version));
    RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->description));

    if (version >= 5)
    {
        RT_SAFE_RET(RT_ReadTerminatedString(fp, &details->link));
    }

    return RT_SUCCESS;
}

RTErrorT RT_FrostyLoadMod(FILE* fp, RTFrostyModT** outMod)
{
    if (fp == NULL)
    {
        return RT_ERROR_INVALID_ARGUMENT;
    }

    // Allocate new mod
    RTFrostyModT* mod = malloc(sizeof(RTFrostyModT));
    if (mod == NULL)
    {
        return RT_ERROR_ALLOCATION_FAILED;
    }

    // Zero-out to avoid panics when freeing after an error
    memset(mod, 0, sizeof(RTFrostyModT));

    mod->fp = fp;

    RTErrorT parseErr = _ParseModHeader(fp, mod);
    if (parseErr != RT_SUCCESS)
    {
        RT_FrostyDestroyMod(mod);
        return parseErr;
    }

    parseErr = _ParseModDetails(fp, &mod->details, mod->version);
    if (parseErr != RT_SUCCESS)
    {
        RT_FrostyDestroyMod(mod);
        return parseErr;
    }

    RT_LogF("Parsing mod '%s' by '%s'", mod->details.title, mod->details.author);

    parseErr = RT_FrostyParseResources(fp, &mod->resources, mod->version);
    if (parseErr != RT_SUCCESS)
    {
        RT_FrostyDestroyMod(mod);
        return parseErr;
    }

    if (outMod != NULL)
    {
        *outMod = mod;
        return RT_SUCCESS;
    }

    RT_FrostyDestroyMod(mod);
    return RT_SUCCESS;
}

RTErrorT RT_FrostyReadModResource(RTFrostyModT* mod, RTFrostyResourceT* resource, char** outBuf, size_t* outSize)
{
    if (resource->resourceIndex == -1)
    {
        return RT_ERROR_INVALID_ARGUMENT;
    }

    int64_t offset = mod->dataOffset + (resource->resourceIndex * 16);

    fseek(mod->fp, offset, SEEK_SET);

    int64_t dataOffset = 0;
    RT_READ_FP(dataOffset, int64_t, mod->fp);

    int64_t dataSize = 0;
    RT_READ_FP(dataSize, int64_t, mod->fp);

    offset = mod->dataOffset + (mod->dataCount * 16) + dataOffset;

    fseek(mod->fp, offset, SEEK_SET);

    char* buffer = malloc(dataSize);
    if (buffer == NULL)
    {
        return RT_ERROR_ALLOCATION_FAILED;
    }

    // Copy the resource data to the new buffer
    fread(buffer, dataSize, 1, mod->fp);

    // Intercept and decompress if EBX
    if ((resource->type == FrostyResourceType_Ebx || resource->type == FrostyResourceType_Res ||
            resource->type == FrostyResourceType_Chunk) &&
        resource->handlerHash == 0)
    {
        return RT_FrostyDecompressEbx(buffer, dataSize, outBuf, outSize);
    }

    if (outBuf != NULL)
    {
        *outBuf = buffer;
    }

    if (outSize != NULL)
    {
        *outSize = dataSize;
    }

    return RT_SUCCESS;
}

void _DestroyModDetails(FrostyModDetailsT details)
{
    RT_SafeFree(details.title);
    RT_SafeFree(details.author);
    RT_SafeFree(details.category);
    RT_SafeFree(details.version);
    RT_SafeFree(details.description);
    RT_SafeFree(details.link);
}

void RT_FrostyDestroyMod(RTFrostyModT* mod)
{
    if (mod == NULL)
    {
        return;
    }

    // Free metadata
    _DestroyModDetails(mod->details);

    // Free resources
    if (mod->resources != NULL)
    {
        size_t resourceCount = RT_ArrayGetSize(mod->resources);
        for (size_t i = 0; i < resourceCount; ++i)
        {
            RTFrostyResourceT* resource = RT_ArrayGetElement(mod->resources, i);
            if (resource == NULL)
            {
                continue;
            }

            RT_FrostyDestroyResource(resource);
        }
        RT_ArrayDestroy(mod->resources);
    }

    // Free mod
    RT_SafeFree(mod->profile);
    fclose(mod->fp);

    free(mod);
}