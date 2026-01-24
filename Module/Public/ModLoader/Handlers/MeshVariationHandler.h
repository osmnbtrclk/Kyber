#pragma once

#include <ModLoader/CustomAssetHandler.h>

#include <SDK/TypeInfo.h>

#include <map>
#include <cstdint>

namespace Kyber
{
struct TextureShaderParameterMergeData
{
    EbxImportReference value;
    std::string parameterName;
};

struct MeshVariationDatabaseMergeDataMaterial
{
    EbxImportReference material;
    EbxImportReference materialVariation;
    int64_t materialId;
    std::vector<TextureShaderParameterMergeData> textureParameters;
    Guid surfaceShaderGuid;
    uint32_t surfaceShaderId;
};

struct MeshVariationDatabaseMergeDataEntry
{
    EbxImportReference mesh;
    std::vector<MeshVariationDatabaseMergeDataMaterial> materials;
    uint32_t variationAssetNameHash;
};

struct MeshVariationMergeData : public CustomAssetHandlerData
{
    std::vector<MeshVariationDatabaseMergeDataEntry> values;
};

class MeshVariationHandler : public GenericCustomAssetHandler<MeshVariationMergeData>
{
public:
    MeshVariationHandler();

    void Load(const eastl::string& modName, bb::ByteBuffer& buf, MeshVariationMergeData* data) override;
    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, MeshVariationMergeData* data) override;
};
} // namespace Kyber
