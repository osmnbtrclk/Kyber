struct EnlightenShaderDatabaseCookie {
    u32 dataSize;
    u32 numMaterials;
    u32 pad[2];
};

struct Guid {
    u8 data[16];
};

struct Vec3 {
    float x;
    float y;
    float z;
    float w;
};

enum RadiosityBackfaceType : u32 {
    Invalid = 0,
    Black = 1,
    Translucent = 2,
    Transparent = 3
};

struct EnlightenMaterial {
    Guid materialGuid;
    Guid radiosityMaterialInstanceGuid;
    Vec3 color;
    u32 fluxMaterialVariationHash;
    float emissiveIntensity;
    float opacity;
    RadiosityBackfaceType backfaceType;
};

struct EnlightenShaderDatabase {
    EnlightenShaderDatabaseCookie meta;
    EnlightenMaterial materials[meta.numMaterials];
};

EnlightenShaderDatabase db @ 0x00;
