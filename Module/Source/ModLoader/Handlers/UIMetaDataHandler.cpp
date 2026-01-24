// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <ModLoader/Handlers/UIMetaDataHandler.h>

#include <ModLoader/ModLoader.h>
#include <Core/Program.h>
#include <Utilities/StringUtils.h>

namespace Kyber
{
UIMetaDataHandler::UIMetaDataHandler()
    : GenericCustomAssetHandler(CustomAssetHandlerLoadStage_ReferencesResolved)
{}

void UIMetaDataHandler::Load(const eastl::string& modName, bb::ByteBuffer& buf, UIMetaDataMergeData* data)
{
    KYBER_LOG(Debug, "Starting UI metadata load");
    int32_t count = buf.getInt();
    for (int i = 0; i < count; i++)
    {
        data->values.push_back(parseReference(buf));
    }
    KYBER_LOG(Debug, "Loaded " << count << " new menudata IDs");
}

bool UIMetaDataHandler::Modify(CustomAssetHandlerContext& ctx, DataContainer* container, UIMetaDataMergeData* data)
{
    UIMetaDataAsset* asset = static_cast<UIMetaDataAsset*>(container);

    // Make sure it's safe to extend the array;
    // all references need to be resolved.
    // Returning false here kicks the resource
    // manager and calls this function again.
    for (int i = 0; i < asset->Assets.size(); i++)
    {
        if (asset->Assets[i] == nullptr)
        {
            KYBER_LOG(Warning, "Failing to update UI Meta Data, something at " << i << " is null!");
            return false;
        }
    }

    uint32_t oldSize = asset->Assets.size();
    uint32_t addedSize = data->values.size();

    asset->Assets.extend(addedSize);
    for (int i = 0; i < addedSize; i++)
    {
        UIMetaDataAsset* newAsset = (UIMetaDataAsset*)findDataContainer(ctx.runtimeDatabaseDomain, data->values[i], "UIMetaData");
        asset->Assets.m_data[oldSize + i] = newAsset;

        newAsset->addRef();
    }

    KYBER_LOG(Info, "[ModLoader] Added " << addedSize << " assets to " << asset->Name);
    return true;
}
} // namespace Kyber
