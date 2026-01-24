// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include "parse_common.h"

#include <stdlib.h>
#include <string.h>

RTErrorT RT_ReadSizedString(FILE* fp, char** outStr)
{
    // Read and allocate string size
    size_t strSize = 0;
    RT_READ_FP(strSize, uint8_t, fp);

    char* str = malloc(strSize + 1);
    if (str == NULL)
    {
        return RT_ERROR_ALLOCATION_FAILED;
    }

    // Copy string into the new buffer
    fread(str, strSize, 1, fp);

    // Null terminate
    str[strSize] = 0;

    if (outStr != NULL)
    {
        *outStr = str;
    }

    return RT_SUCCESS;
}

RTErrorT RT_ReadTerminatedString(FILE* fp, char** outStr)
{
    size_t maxStrSize = 1024;
    size_t strSize = 0;
    char* buf = malloc(maxStrSize);
    if (buf == NULL) {
        return RT_ERROR_ALLOCATION_FAILED;
    }

    int c;
    while ((c = fgetc(fp)) != EOF && c != '\0') {
        if (strSize >= maxStrSize - 1) {
            maxStrSize *= 2;

            char* newBuf = realloc(buf, maxStrSize);
            if (newBuf == NULL) {
                free(buf);
                return RT_ERROR_ALLOCATION_FAILED;
            }
            
            buf = newBuf;
        }

        buf[strSize++] = (char)c;
    }
    buf[strSize] = '\0';

    if (outStr != NULL) {
        *outStr = buf;
    } else {
        free(buf);
    }

    if (c == EOF) {
        return RT_ERROR_READ_FAILED;
    }

    return RT_SUCCESS;
}

void RT_ReadSha1(FILE* fp, char* outBuf)
{
    int32_t sha1TypeSize = 20 * sizeof(uint8_t);
    fread(outBuf, sha1TypeSize, 1, fp);
}
