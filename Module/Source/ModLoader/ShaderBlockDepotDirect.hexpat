struct ShaderBlockResource {
    u64 hash;
};

struct ShaderStaticParamDbBlock : ShaderBlockResource {
    u64 offset;
    u64 size;
    
    s32 indices[size] @ offset;
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
    
    ParameterHolder @ offset;
};

struct MeshParamDbBlock : ShaderBlockResource {
    u64 offset;
    u64 size;
    s32 lodIndex;
    
    ParameterHolder @ offset;
};

struct MeshVariationEntry {
    u8 guid[16];
    s32 int;
};

struct ShaderBlockMeshVariationEntry : ShaderBlockResource {
    u64 offset;
    u64 count;
    MeshVariationEntry entries[count] @ offset;
};

struct Entry {
    u64 offset;
    u64 type;
    
    match (type) {
        (0): ShaderStaticParamDbBlock data @ offset;
        (1): ShaderPersistentParamDbBlock data @ offset;
        (2): ShaderStaticParamDbBlock data @ offset;
        (3): MeshParamDbBlock data @ offset;
        (4): ShaderBlockMeshVariationEntry data @ offset;
    }
};

Entry entries[3] @ 0x00;