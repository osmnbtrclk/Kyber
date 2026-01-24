#pragma once

#include <cstdio>

#include <EASTL/internal/config.h>

namespace Kyber
{
static void* dummyAllocate(EASTLArenaAllocator* inst, size_t n)
{
    return nullptr;
}

static void* dummyAllocateAlign(EASTLArenaAllocator* inst, size_t n, size_t alignment)
{
    return nullptr;
}

static void dummyDeallocate(EASTLArenaAllocator* inst, void* p, size_t n) {}

EASTLArenaAllocator::EASTLArenaAllocatorAllocateFunc EASTLArenaAllocator::s_allocateFunc = dummyAllocate;
EASTLArenaAllocator::EASTLArenaAllocatorAllocateAlignFunc EASTLArenaAllocator::s_allocateAlignFunc = dummyAllocateAlign;
EASTLArenaAllocator::EASTLArenaAllocatorDeallocateFunc EASTLArenaAllocator::s_deallocateFunc = dummyDeallocate;

void* EASTLArenaAllocator::allocate(size_t n, int flags)
{
    return s_allocateFunc(this, n);
}

void* EASTLArenaAllocator::allocate(size_t n, size_t alignment, size_t offset, int flags)
{
    return s_allocateAlignFunc(this, n, alignment);
}

void EASTLArenaAllocator::deallocate(void* p, size_t n)
{
    s_deallocateFunc(this, p, n);
}

EASTLArenaAllocator* GlobalEASTLArenaAllocator()
{
    static EASTLArenaAllocator staticInstance;
    return &staticInstance;
}
} // namespace Kyber
