#pragma once

#if defined(_WIN32)
#else
#include <stdint.h>
#include <time.h>
typedef int64_t __time64_t;
#endif

#include "Vxc.h"
#include "VxcRequests.h"
#include "VxcResponses.h"
#include "VxcErrors.h"
#include "VxcTypes.h"
