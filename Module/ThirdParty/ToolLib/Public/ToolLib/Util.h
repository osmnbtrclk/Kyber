#pragma once

#include <string>

#include <cstdint>

void tlInvokeCrash(const std::string& reason);

// Memory
void tlSetBytes(void* dst, int32_t val, uint32_t size = 1);
void tlCopyBytes(void* dst, void* src, uint32_t size = 1);
void tlNopBytes(void* dst, uint32_t size = 1);
