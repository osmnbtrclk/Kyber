// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include "frosty_resource.h"

#include "parse_common.h"

#include <zstd.h>

#include <stdlib.h>
#include <string.h>

char* s_emptyResourceName = "Empty";

RTErrorT RT_FrostyParseResource(FILE* fp, RTFrostyResourceT* resource, uint32_t version)
{
    RT_READ_FP(resource->type, uint8_t, fp);

    ++resource->type;

    RT_READ_FP(resource->resourceIndex, int32_t, fp);

    if ((version <= 3 && resource->resourceIndex != -1) || version > 3)
    {
        RT_SAFE_RET(RT_ReadTerminatedString(fp, &resource->name));
    }
    else
    {
        resource->name = NULL;
    }

    if (resource->resourceIndex != -1)
    {
        RT_ReadSha1(fp, resource->sha1);

        RT_READ_FP(resource->size, int64_t, fp);
        RT_READ_FP(resource->flags, uint8_t, fp);
        RT_READ_FP(resource->handlerHash, int32_t, fp);

        if (version >= 3)
        {
            RT_SAFE_RET(RT_ReadTerminatedString(fp, &resource->userData));
        }
        else
        {
            resource->userData = NULL;
        }
    }

    RT_SAFE_RET(RT_ArrayCreate(sizeof(uintptr_t), &resource->addedBundles));

    int32_t count = 0;
    if (version <= 3 && resource->resourceIndex != -1)
    {
        RT_READ_FP(count, int32_t, fp);
        for (int32_t i = 0; i < count; ++i)
        {
            int32_t _ = 0;
            RT_READ_FP(_, int32_t, fp);
        }

        RT_READ_FP(count, int32_t, fp);
        for (int32_t i = 0; i < count; ++i)
        {
            uintptr_t bundleHash = 0;
            RT_READ_FP(bundleHash, uint32_t, fp);
            RT_SAFE_RET(RT_ArrayAppend(resource->addedBundles, (void*)bundleHash));
        }
    }
    else if (version > 3)
    {
        RT_READ_FP(count, int32_t, fp);
        for (int32_t i = 0; i < count; ++i)
        {
            uintptr_t bundleHash = 0;
            RT_READ_FP(bundleHash, uint32_t, fp);
            RT_SAFE_RET(RT_ArrayAppend(resource->addedBundles, (void*)bundleHash));
        }
    }
    else
    {
        RT_LogF("Skipping bundles", count);
    }

    // Special handling for bundle/res/chunk resources
    if (resource->type == FrostyResourceType_Bundle)
    {
        RT_SAFE_RET(RT_ReadTerminatedString(fp, &resource->name));

        int32_t count = 0;
        RT_READ_FP(count, int32_t, fp);
    }
    else if (resource->type == FrostyResourceType_Res)
    {
        RT_READ_FP(resource->resType, uint32_t, fp);
        RT_READ_FP(resource->resRid, uint64_t, fp);

        int32_t metaSize = 0;
        RT_READ_FP(metaSize, int32_t, fp);

        fread(resource->resMeta, metaSize, 1, fp);
    }
    else if (resource->type == FrostyResourceType_Chunk)
    {
        RT_READ_FP(resource->rangeStart, uint32_t, fp);
        RT_READ_FP(resource->rangeEnd, uint32_t, fp);
        RT_READ_FP(resource->logicalOffset, uint32_t, fp);
        RT_READ_FP(resource->logicalSize, uint32_t, fp);
        RT_READ_FP(resource->h32, int32_t, fp);
        RT_READ_FP(resource->firstMip, int32_t, fp);

        if (resource->firstMip == -1 && resource->rangeStart != 0)
        {
            resource->firstMip = 0;
        }
    }

    if (resource->name == NULL)
    {
        RT_LogF("Resource has no name! Type: %d", resource->type);
        resource->name = s_emptyResourceName;
    }

    return RT_SUCCESS;
}

RTErrorT RT_FrostyParseResources(FILE* fp, RTArrayT** outResources, uint32_t version)
{
    int32_t count = 0;
    RT_READ_FP(count, int32_t, fp);

    RTArrayT* arr;
    RT_SAFE_RET(RT_ArrayCreate(sizeof(RTFrostyResourceT*), &arr));

    RT_LogF("Reading %d resources", count);

    for (int32_t i = 0; i < count; ++i)
    {
        RTFrostyResourceT* resource = malloc(sizeof(RTFrostyResourceT));
        if (resource == NULL)
        {
            return RT_ERROR_ALLOCATION_FAILED;
        }

        memset(resource, 0, sizeof(RTFrostyResourceT));

        // Parse and append the resource
        RT_SAFE_RET(RT_FrostyParseResource(fp, resource, version));
        RT_SAFE_RET(RT_ArrayAppend(arr, resource));
    }

    if (outResources != NULL)
    {
        *outResources = arr;
    }

    return RT_SUCCESS;
}

void RT_FrostyDestroyResource(RTFrostyResourceT* resource)
{
    if (resource == NULL)
    {
        return;
    }

    if (resource->name != s_emptyResourceName)
    {
        RT_SafeFree(resource->name);
    }
    
    RT_SafeFree(resource->userData);
    RT_ArrayDestroy(resource->addedBundles);

    free(resource);
}

static uint32_t _SwapEndiannessU32(uint32_t val)
{
    return ((val >> 24) & 0xff) | ((val << 8) & 0xff0000) | ((val >> 8) & 0xff00) | ((val << 24) & 0xff000000);
}

static int32_t _SwapEndiannessS32(int32_t val)
{
    int32_t result = 0;
    result |= (val & 0x000000FF) << 24;
    result |= (val & 0x0000FF00) << 8;
    result |= (val & 0x00FF0000) >> 8;
    result |= (val & 0xFF000000) >> 24;
    return result;
}

static uint16_t _SwapEndiannessU16(uint16_t val)
{
    uint16_t result = 0;
    result |= (val & 0x00FF) << 8;
    result |= (val & 0xFF00) >> 8;
    return result;
}

RTErrorT RT_FrostyDecompressEbx(const char* buf, size_t size, char** outBuf, size_t* outSize)
{
    char* writer = calloc(0, sizeof(uint8_t));
    size_t total = 0;

    while (size > 0)
    {
        // Read chunk meta
        uint32_t bufferSize = RT_READ_BUF(uint32_t, &buf);
        bufferSize = _SwapEndiannessU32(bufferSize);

        // There are some weird huge resources that fail to decompress
        if (bufferSize > 0x10000)
        {
            RT_LogF("Failing to read resource of size %d (%d)", bufferSize, size);
            return RT_ERROR_RESOURCE_TOO_BIG;
        }

        uint16_t compressCode = RT_READ_BUF(uint16_t, &buf);
        RT_UNUSED(compressCode);

        uint16_t compressSize = RT_READ_BUF(uint16_t, &buf);
        compressSize = _SwapEndiannessU16(compressSize);

        // Extend the buffer
        char* newBuf = realloc(writer, total + bufferSize);
        if (newBuf == NULL)
        {
            free(writer);
            return RT_ERROR_ALLOCATION_FAILED;
        }
        writer = newBuf;

        // Decompress
        size_t err = ZSTD_decompress(writer + total, bufferSize, buf, compressSize);
        if (ZSTD_isError(err))
        {
            RT_LogF("Decompression failed: %s", ZSTD_getErrorName(err));
            return RT_ERROR_DECOMPRESSION_FAILED;
        }

        buf += compressSize;

        size -= (size_t)compressSize + 8;
        total += bufferSize;
    }

    if (outBuf != NULL)
    {
        *outBuf = writer;
    }

    if (outSize != NULL)
    {
        *outSize = total;
    }

    return RT_SUCCESS;
}
