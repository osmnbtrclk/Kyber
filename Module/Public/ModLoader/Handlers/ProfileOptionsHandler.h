#pragma once

#include <ModLoader/CustomAssetHandler.h>

#include <SDK/TypeInfo.h>

namespace Kyber
{
struct ProfileOptionsMergeData : public CustomAssetHandlerData
{
    std::vector<EbxImportReference> options;
};

class ProfileOptionsHandler : public GenericCustomAssetHandler<ProfileOptionsMergeData>
{
public:
    ProfileOptionsHandler();

    void Load(const eastl::string& modName, bb::ByteBuffer& buf, ProfileOptionsMergeData* data) override;
    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, ProfileOptionsMergeData* data) override;
};
} // namespace Kyber
