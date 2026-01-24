#pragma once

#include <ModLoader/CustomAssetHandler.h>

#include <SDK/TypeInfo.h>

namespace Kyber
{
struct UIMetaDataMergeData : public CustomAssetHandlerData
{
    std::vector<EbxImportReference> values;
};

class UIMetaDataHandler : public GenericCustomAssetHandler<UIMetaDataMergeData>
{
public:
    UIMetaDataHandler();

    void Load(const eastl::string& modName, bb::ByteBuffer& buf, UIMetaDataMergeData* data) override;
    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, UIMetaDataMergeData* data) override;
};
} // namespace Kyber
