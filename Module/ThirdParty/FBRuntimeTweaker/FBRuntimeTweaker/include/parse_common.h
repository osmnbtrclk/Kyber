// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include "util.h"

#include <stdio.h>

EXTERN_C_BLOCK_START

// Read a string with a size byte prefix
RTErrorT RT_ReadSizedString(FILE* fp, char** outStr);

// Read a null-terminated string
RTErrorT RT_ReadTerminatedString(FILE* fp, char** outStr);

// Read a 20-byte SHA1 hash without allocating new memory
void RT_ReadSha1(FILE* fp, char* outBuf);

EXTERN_C_BLOCK_END