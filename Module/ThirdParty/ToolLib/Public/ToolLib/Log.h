#pragma once

#include <spdlog/spdlog.h>

#define TL_INFO(fmt, ...) spdlog::info(fmt, __VA_ARGS__)
#define TL_WARN(fmt, ...) spdlog::warn(fmt, __VA_ARGS__)
#define TL_ERROR(fmt, ...) spdlog::error(fmt, __VA_ARGS__)