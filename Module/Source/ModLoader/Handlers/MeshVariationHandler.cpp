// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <ModLoader/Handlers/MeshVariationHandler.h>

#include <ModLoader/ModLoader.h>
#include <Core/Program.h>
#include <Utilities/StringUtils.h>

namespace Kyber
{
MeshVariationHandler::MeshVariationHandler()
    : GenericCustomAssetHandler(CustomAssetHandlerLoadStage_ReferencesResolved)
{}

void MeshVariationHandler::Load(const eastl::string& modName, bb::ByteBuffer& buf, MeshVariationMergeData* data)
{
    KYBER_LOG(Debug, "[ModLoader] Starting mesh variation load for " << modName.c_str());
    int32_t entriesCount = buf.getInt();
    for (int i = 0; i < entriesCount; i++)
    {
        MeshVariationDatabaseMergeDataEntry entry;
        entry.mesh = parseReference(buf);
        entry.variationAssetNameHash = buf.getInt();
        int32_t materialsCount = buf.getInt();
        for (int j = 0; j < materialsCount; j++)
        {
            MeshVariationDatabaseMergeDataMaterial material;
            material.material = parseReference(buf);
            material.materialVariation = parseReference(buf);
            material.materialId = buf.getLong();
            material.surfaceShaderGuid = Guid::FromFrostyLE(buf);
            material.surfaceShaderId = buf.getInt();
            int32_t texturesCount = buf.getInt();
            for (int k = 0; k < texturesCount; k++)
            {
                TextureShaderParameterMergeData texture;
                texture.value = parseReference(buf);
                texture.parameterName = buf.getNullTerminatedString();
                material.textureParameters.push_back(texture);
            }
            entry.materials.push_back(material);
        }
        data->values.push_back(entry);
    }
    KYBER_LOG(Debug, "[ModLoader] Loaded " << entriesCount << " new mesh variations");
}

bool MeshVariationHandler::Modify(CustomAssetHandlerContext& ctx, DataContainer* container, MeshVariationMergeData* data)
{
    MeshVariationDatabase* db = static_cast<MeshVariationDatabase*>(container);

    if (ctx.clearRequired)
    {
        db->Entries.init(0);
        db->RedirectEntries.init(0);
    }

    uint32_t prevSize = db->Entries.size();
    uint32_t addedCount = data->values.size();

    KYBER_LOG(Debug, "[ModLoader] Adding " << addedCount << " new mesh variations to " << prevSize << " existing ones");

    db->Entries.extend(addedCount);
    for (int i = 0; i < addedCount; i++)
    {
        const auto& entry = data->values[i];

        MeshVariationDatabaseEntry realEntry;
        realEntry.Mesh = (Asset*)findDataContainer(ctx.runtimeDatabaseDomain, entry.mesh, "Mesh");
        realEntry.VariationAssetNameHash = entry.variationAssetNameHash;

        if (realEntry.Mesh != nullptr)
        {
            realEntry.Mesh->addRef();
        }

        uint32_t materialCount = entry.materials.size();
        realEntry.Materials.init(materialCount);
        for (int j = 0; j < materialCount; j++)
        {
            const auto& material = entry.materials[j];

            MeshVariationDatabaseMaterial realMaterial;
            realMaterial.Material = findDataContainer(ctx.runtimeDatabaseDomain, material.material, "Material");
            realMaterial.MaterialVariation = findDataContainer(ctx.runtimeDatabaseDomain, material.materialVariation, "MaterialVariation");
            realMaterial.SurfaceShaderId = material.surfaceShaderId;
            realMaterial.SurfaceShaderGuid = material.surfaceShaderGuid;
            realMaterial.MaterialId = material.materialId;

            if (realMaterial.Material != nullptr)
            {
                realMaterial.Material->addRef();
            }

            uint32_t textureCount = material.textureParameters.size();
            realMaterial.TextureParameters.init(textureCount);
            for (int k = 0; k < textureCount; k++)
            {
                const auto& texture = material.textureParameters[k];

                TextureShaderParameter realTexture;
                realTexture.Value = (Asset*)findDataContainer(ctx.runtimeDatabaseDomain, texture.value, "Texture Value");
                realTexture.ParameterName = (char*)StringUtils::CopyWithArena(texture.parameterName);
                realMaterial.TextureParameters.m_data[k] = realTexture;

                if (realTexture.Value != nullptr)
                {
                    realTexture.Value->addRef();
                }
            }

            realEntry.Materials.m_data[j] = realMaterial;
        }

        db->Entries.m_data[prevSize + i] = realEntry;
    }

    KYBER_LOG(Debug, "[ModLoader] Done adding new mesh variations, new size is " << db->Entries.size());
    return true;
}
} // namespace Kyber
