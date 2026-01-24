#pragma once

#include <EABase/eabase.h>

namespace Kyber
{
class MemoryArena;

class EASTLArenaAllocator
{
public:
    EASTLArenaAllocator(const char* pName = nullptr) : m_arena(nullptr) {}
    EASTLArenaAllocator(const EASTLArenaAllocator& x) : m_arena(x.m_arena) {}
    EASTLArenaAllocator(const EASTLArenaAllocator& x, const char* pName) : m_arena(x.m_arena) {}

    EASTLArenaAllocator& operator=(const EASTLArenaAllocator& x) { return *this; }

    void* allocate(size_t n, int flags = 0);
    void* allocate(size_t n, size_t alignment, size_t offset, int flags = 0);
    void deallocate(void* p, size_t n);

    const char* get_name() const
    {
        return "";
    }
    
    void set_name(const char* pName) {}

    typedef void* (*EASTLArenaAllocatorAllocateFunc)(EASTLArenaAllocator* inst, size_t n);
    typedef void* (*EASTLArenaAllocatorAllocateAlignFunc)(EASTLArenaAllocator* inst, size_t n, size_t alignment);
    typedef void (*EASTLArenaAllocatorDeallocateFunc)(EASTLArenaAllocator* inst, void* p, size_t n);

    static EASTLArenaAllocatorAllocateFunc s_allocateFunc;
    static EASTLArenaAllocatorAllocateAlignFunc s_allocateAlignFunc;
    static EASTLArenaAllocatorDeallocateFunc s_deallocateFunc;

private:
    MemoryArena* m_arena;
};

EASTLArenaAllocator* GlobalEASTLArenaAllocator();

#define EASTLAllocatorDefault ::Kyber::GlobalEASTLArenaAllocator
#define EASTLAllocatorType ::Kyber::EASTLArenaAllocator
} // namespace Kyber
