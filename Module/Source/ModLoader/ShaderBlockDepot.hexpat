#define OFFSET 16

struct ShaderBlockResource {
    u64 hash;
};

struct ShaderStaticParamDbBlock : ShaderBlockResource {
    u64 offset;
    u64 size;
    
    s32 indices[size] @ offset + OFFSET;
};

struct ParameterEntry {
    u64 parameterHash;
    u32 typeHash;
    u16 used;
    u16 nameHash;
    s32 size;
    
    if (typeHash == 0xad0abfd3) {
        size = 16;
    }
    
    u8 value[size];
};

struct ParameterHolder {
    s32 count;
    ParameterEntry entries[count];
};

struct ShaderPersistentParamDbBlock : ShaderBlockResource {
    u64 offset;
    u64 size;
    
    ParameterHolder @ offset + OFFSET;
};

struct MeshParamDbBlock : ShaderBlockResource {
    u64 offset;
    u64 size;
    s32 lodIndex;
    
    ParameterHolder @ offset + OFFSET;
};

struct MeshVariationEntry {
    u8 guid[16];
    s32 int;
};

struct ShaderBlockMeshVariationEntry : ShaderBlockResource {
    u64 offset;
    u64 count;
    MeshVariationEntry entries[count] @ offset + OFFSET;
};

struct Entry {
    u64 offset;
    u64 type;
    
    match (type) {
        (0): ShaderStaticParamDbBlock data @ offset + OFFSET;
        (1): ShaderPersistentParamDbBlock data @ offset + OFFSET;
        (2): ShaderStaticParamDbBlock data @ offset + OFFSET;
        (3): MeshParamDbBlock data @ offset + OFFSET;
        (4): ShaderBlockMeshVariationEntry data @ offset + OFFSET;
    }
};

struct ShaderBlockDepot {
    u32 N000012C9;
    u32 fullSize;
    u32 relocTableCount;
    u32 sbResourceCount;
    
    Entry entries[sbResourceCount];
};

ShaderBlockDepot depot @ 0x00;