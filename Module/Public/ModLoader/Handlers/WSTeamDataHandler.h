#pragma once

#include <ModLoader/CustomAssetHandler.h>

#include <SDK/TypeInfo.h>

namespace Kyber
{
struct TeamKitMergeData
{
    EbxImportReference kitRef;
    uint32_t classIdentifier;
    uint32_t gpIdentifier;
};

struct WSTeamDataMergeData : public CustomAssetHandlerData
{
    bool isAdded;
    Guid partitionGuid;
    Guid rootInstanceGuid;
    int32_t internalId;

    EbxImportReference wsFaction;
    uint32_t wsPlanetId;

    std::vector<TeamKitMergeData> soldiers;
    std::vector<EbxImportReference> apSoldiers;
    std::vector<TeamKitMergeData> specialSoldiers;
    std::vector<EbxImportReference> apSpecialSoldiers;
    std::vector<TeamKitMergeData> heroes;
    std::vector<EbxImportReference> apHeroes;
    std::vector<TeamKitMergeData> vehicles;
    std::vector<EbxImportReference> apVehicles;
    std::vector<TeamKitMergeData> heroVehicles;
    std::vector<EbxImportReference> apHeroVehicles;

    std::vector<EbxImportReference> allPlayerAbilities;
};

class WSTeamDataHandler : public GenericCustomAssetHandler<WSTeamDataMergeData>
{
public:
    WSTeamDataHandler();

    void LoadLegacy(bb::ByteBuffer& buf, WSTeamDataMergeData* data);
    void Load(const eastl::string& modName, bb::ByteBuffer& buf, WSTeamDataMergeData* data) override;
    void PreModify(EbxPartitionReader& reader, WSTeamDataMergeData* data) override;
    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, WSTeamDataMergeData* data) override;
};
} // namespace Kyber
