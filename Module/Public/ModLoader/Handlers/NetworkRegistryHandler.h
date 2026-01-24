#pragma once

#include <ModLoader/CustomAssetHandler.h>

#include <SDK/TypeInfo.h>

namespace Kyber
{
struct NetworkRegistryMergeData : public CustomAssetHandlerData
{
    std::vector<EbxImportReference> values;
};

class NetworkRegistryHandler : public GenericCustomAssetHandler<NetworkRegistryMergeData>
{
public:
    NetworkRegistryHandler();

    void Load(const eastl::string& modName, bb::ByteBuffer& buf, NetworkRegistryMergeData* data) override;
    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, NetworkRegistryMergeData* data) override;
};
} // namespace Kyber
