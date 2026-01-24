// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <ModLoader/Handlers/ProfileOptionsHandler.h>

#include <ModLoader/ModLoader.h>
#include <Core/Program.h>
#include <Utilities/StringUtils.h>

namespace Kyber
{
ProfileOptionsHandler::ProfileOptionsHandler()
    : GenericCustomAssetHandler(CustomAssetHandlerLoadStage_ReferencesResolved)
{}

void ProfileOptionsHandler::Load(const eastl::string& modName, bb::ByteBuffer& buf, ProfileOptionsMergeData* data)
{
    KYBER_LOG(Debug, "Starting profile options load");
    int32_t count = buf.getInt();
    for (int i = 0; i < count; i++)
    {
        data->options.push_back(parseReference(buf));
    }
    KYBER_LOG(Debug, "Loaded " << count << " new profile options");
}

bool ProfileOptionsHandler::Modify(CustomAssetHandlerContext& ctx, DataContainer* container, ProfileOptionsMergeData* data)
{
    ProfileOptionsAsset* asset = static_cast<ProfileOptionsAsset*>(container);

    // Make sure it's safe to extend the array;
    // all references need to be resolved.
    // Returning false here kicks the resource
    // manager and calls this function again.
    for (int i = 0; i < asset->Options.size(); i++)
    {
        if (asset->Options[i] == nullptr)
        {
            KYBER_LOG(Warning, "Failing to update Profile Options, something at " << i << " is null!");
            return false;
        }
    }

    uint32_t oldSize = asset->Options.size();
    uint32_t addedSize = data->options.size();

    asset->Options.extend(addedSize);
    for (int i = 0; i < addedSize; i++)
    {
        UIMetaDataAsset* newAsset = (UIMetaDataAsset*)findDataContainer(ctx.runtimeDatabaseDomain, data->options[i], "ProfileOptionData");
        asset->Options.m_data[oldSize + i] = newAsset;

        newAsset->addRef();
    }

    KYBER_LOG(Debug, "Added " << addedSize << " assets to " << asset->Name);
    return true;
}
} // namespace Kyber
