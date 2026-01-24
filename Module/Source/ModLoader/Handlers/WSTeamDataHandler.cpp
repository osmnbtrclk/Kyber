// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <ModLoader/Handlers/WSTeamDataHandler.h>

#include <ModLoader/ModLoader.h>
#include <Core/Program.h>
#include <Utilities/StringUtils.h>
#include <unordered_set>

namespace Kyber
{
const int32_t kHandlerVersion = 3;

WSTeamDataHandler::WSTeamDataHandler()
    : GenericCustomAssetHandler(CustomAssetHandlerLoadStage_ReferencesResolved)
{}

void WSTeamDataHandler::LoadLegacy(bb::ByteBuffer& buf, WSTeamDataMergeData* data)
{
    data->wsFaction = parseReference2(buf);

    // Soldiers
    int32_t count = buf.getInt();
    data->soldiers.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        data->soldiers.push_back(entry);
    }

    // AP Soldiers
    count = buf.getInt();
    data->apSoldiers.reserve(count);

    for (int i = 0; i < count; i++)
    {
        data->apSoldiers.push_back(parseReference(buf));
    }

    // Special Soldiers
    count = buf.getInt();
    data->specialSoldiers.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        data->specialSoldiers.push_back(entry);
    }

    // AP Special Soldiers
    count = buf.getInt();
    data->apSpecialSoldiers.reserve(count);

    for (int i = 0; i < count; i++)
    {
        data->apSpecialSoldiers.push_back(parseReference(buf));
    }

    // Heroes
    count = buf.getInt();
    data->heroes.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        data->heroes.push_back(entry);
    }

    // AP Heroes
    count = buf.getInt();
    data->apHeroes.reserve(count);

    for (int i = 0; i < count; i++)
    {
        data->apHeroes.push_back(parseReference(buf));
    }

    // Vehicles
    count = buf.getInt();
    data->vehicles.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        data->vehicles.push_back(entry);
    }

    // AP Vehicles
    count = buf.getInt();
    data->apVehicles.reserve(count);

    for (int i = 0; i < count; i++)
    {
        data->apVehicles.push_back(parseReference(buf));
    }

    // Hero Vehicles
    count = buf.getInt();
    data->heroVehicles.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        data->heroVehicles.push_back(entry);
    }

    // AP Hero Vehicles
    count = buf.getInt();
    data->apHeroVehicles.reserve(count);

    for (int i = 0; i < count; i++)
    {
        data->apHeroVehicles.push_back(parseReference(buf));
    }

    if (buf.bytesRemaining() == 0)
    {
        data->wsFaction = { data->wsFaction.instanceGuid, data->wsFaction.partitionGuid };
    }
}

std::vector<TeamKitMergeData> ReadTeamDataKitReferences(bb::ByteBuffer& buf)
{
    int count = buf.getInt();

    std::vector<TeamKitMergeData> kits;
    kits.reserve(count);

    for (int i = 0; i < count; i++)
    {
        TeamKitMergeData entry;
        entry.kitRef = parseReference2(buf);
        entry.classIdentifier = buf.getInt();
        entry.gpIdentifier = buf.getInt();
        bool hiddenIdentifier = buf.get() == 1;
        kits.push_back(entry);
    }

    return kits;
}

std::vector<EbxImportReference> ReadPointerRefs(bb::ByteBuffer& buf)
{
    int count = buf.getInt();

    std::vector<EbxImportReference> refs;
    refs.reserve(count);

    for (int i = 0; i < count; i++)
    {
        refs.push_back(parseReference2(buf));
    }

    return refs;
}

void WSTeamDataHandler::Load(const eastl::string& modName, bb::ByteBuffer& buf, WSTeamDataMergeData* data)
{
    LoadLegacy(buf, data);

    if (buf.bytesRemaining() == 0)
    {
        return;
    }

    std::string magic = buf.getNullTerminatedString();
    int32_t version = buf.getInt();
    if (magic != "MopMagicMopMagic" || version > kHandlerVersion)
    {
        KYBER_LOG(Error, "One of your mods requires a newer version of the SWBF2 Gameplay Merger than Kyber supports. Please update Kyber "
                         "or report this");
        return;
    }

    if (version == 2)
    {
        KYBER_LOG(Error, "One of your mods was exported on a semi-complete version of the new gameplay merger");
        return;
    }

    data->isAdded = buf.get() == 1;
    if (data->isAdded)
    {
        data->partitionGuid = Guid::FromFrostyLE(buf);
        data->rootInstanceGuid = Guid::FromFrostyLE(buf);
        data->internalId = buf.getInt();
    }

    data->wsPlanetId = buf.getInt();

    data->soldiers = ReadTeamDataKitReferences(buf);
    data->apSoldiers = ReadPointerRefs(buf);
    data->heroes = ReadTeamDataKitReferences(buf);
    data->apHeroes = ReadPointerRefs(buf);
    data->specialSoldiers = ReadTeamDataKitReferences(buf);
    data->apSpecialSoldiers = ReadPointerRefs(buf);
    data->vehicles = ReadTeamDataKitReferences(buf);
    data->apVehicles = ReadPointerRefs(buf);
    data->heroVehicles = ReadTeamDataKitReferences(buf);
    data->apHeroVehicles = ReadPointerRefs(buf);

    if (data->isAdded)
    {
        data->allPlayerAbilities = ReadPointerRefs(buf);
        KYBER_LOG(Info, "[ModLoader] Loaded abilities");
    }
}

static void Merge(CustomAssetHandlerContext& ctx, std::vector<TeamKitMergeData>& source, WSSoldierCustomizationKitList* kitList,
    CharacterIdCollection* idCollection, CharacterClassIdCollection* classIdCollection)
{
    kitList->Kits.init(source.size());
    idCollection->Characters.init(source.size());

    for (int i = 0; i < source.size(); i++)
    {
        const auto& kit = source[i];

        Asset* realKit = (Asset*)findDataContainer(ctx.runtimeDatabaseDomain, kit.kitRef, "WSTeamData/Kit");
        kitList->Kits.m_data[i] = realKit;

        auto* characterIdData = new CharacterIdData();
        characterIdData->CharacterClassId = kit.classIdentifier;
        characterIdData->CharacterId = kit.gpIdentifier;
        idCollection->Characters.m_data[i] = characterIdData;
    }

    std::vector<uint32_t> loggedClasses;
    for (int i = 0; i < source.size(); i++)
    {
        const auto& kit = source[i];
        if (std::find(loggedClasses.begin(), loggedClasses.end(), kit.classIdentifier) != loggedClasses.end())
        {
            continue;
        }

        loggedClasses.push_back(kit.classIdentifier);
    }

    classIdCollection->CharacterClasses.init(loggedClasses.size());

    for (int i = 0; i < loggedClasses.size(); i++)
    {
        auto* characterClassIdData = new CharacterClassIdData();
        characterClassIdData->CharacterClassId = loggedClasses[i];
        classIdCollection->CharacterClasses.m_data[i] = characterClassIdData;
    }
}

static void MergeAP(CustomAssetHandlerContext& ctx, std::vector<EbxImportReference>& source, WSSoldierCustomizationKitList* kitList)
{
    kitList->Kits.init(source.size());

    for (int i = 0; i < source.size(); i++)
    {
        const auto& kitRef = source[i];
        Asset* realKit = (Asset*)findDataContainer(ctx.runtimeDatabaseDomain, kitRef, "WSTeamData/APKit");
        kitList->Kits.m_data[i] = realKit;
    }
}

static bool operator==(const EbxImportReference& a, const EbxImportReference& b)
{
    return a.partitionGuid == b.partitionGuid && a.instanceGuid == b.instanceGuid;
}

static bool operator==(const TeamKitMergeData& a, const TeamKitMergeData& b)
{
    return a.kitRef == b.kitRef && a.classIdentifier == b.classIdentifier && a.gpIdentifier == b.gpIdentifier;
}

static std::vector<TeamKitMergeData> removeDuplicates(const std::vector<TeamKitMergeData>& source)
{
    std::vector<TeamKitMergeData> unique;

    for (const auto& data : source)
    {
        bool valid = true;
        for (const auto& kit : unique)
        {
            if (kit.kitRef == data.kitRef && kit.classIdentifier == data.classIdentifier && kit.gpIdentifier == data.gpIdentifier)
            {
                valid = false;
                break;
            }
        }

        if (!valid)
        {
            continue;
        }

        unique.push_back(data);
    }

    return unique;
}

static std::vector<EbxImportReference> removeDuplicates(const std::vector<EbxImportReference>& source)
{
    std::vector<EbxImportReference> unique;

    for (const auto& data : source)
    {
        bool valid = true;
        for (const auto& ref : unique)
        {
            if (ref.partitionGuid.Equals(data.partitionGuid) && ref.instanceGuid.Equals(data.instanceGuid))
            {
                valid = false;
            }
        }

        if (!valid)
        {
            continue;
        }

        unique.push_back(data);
    }

    return unique;
}

#define IMPLEMENT_MERGE(type, source, kitList, idCollection, classIdCollection)                                                            \
    if (!data->source.empty())                                                                                                             \
    {                                                                                                                                      \
        if (teamData->kitList == nullptr)                                                                                                  \
        {                                                                                                                                  \
            teamData->kitList = new type();                                                                                                \
        }                                                                                                                                  \
                                                                                                                                           \
        if (teamData->idCollection == nullptr)                                                                                             \
        {                                                                                                                                  \
            teamData->idCollection = new CharacterIdCollection();                                                                          \
        }                                                                                                                                  \
                                                                                                                                           \
        if (teamData->classIdCollection == nullptr)                                                                                        \
        {                                                                                                                                  \
            teamData->classIdCollection = new CharacterClassIdCollection();                                                                \
        }                                                                                                                                  \
                                                                                                                                           \
        std::vector<TeamKitMergeData> unique = removeDuplicates(data->source);                                                             \
        Merge(ctx, unique, reinterpret_cast<WSSoldierCustomizationKitList*>(teamData->kitList), teamData->idCollection,                    \
            teamData->classIdCollection);                                                                                                  \
    }

#define IMPLEMENT_MERGE_AP(type, source, kitList)                                                                                          \
    if (!data->source.empty())                                                                                                             \
    {                                                                                                                                      \
        if (teamData->kitList == nullptr)                                                                                                  \
        {                                                                                                                                  \
            teamData->kitList = new type();                                                                                                \
        }                                                                                                                                  \
                                                                                                                                           \
        std::vector<EbxImportReference> unique = removeDuplicates(data->source);                                                           \
        MergeAP(ctx, unique, reinterpret_cast<WSSoldierCustomizationKitList*>(teamData->kitList));                                         \
    }

void WSTeamDataHandler::PreModify(EbxPartitionReader& reader, WSTeamDataMergeData* data)
{
    if (!data->isAdded)
    {
        return;
    }

    reader.m_initData.partitionGuid = data->partitionGuid;
    reader.m_initData.primaryInstance->SetInstanceGuid(data->rootInstanceGuid);

    KYBER_LOG(Info, "[ModLoader] Updated WSTeamData IDs for duplicated asset");
}

bool WSTeamDataHandler::Modify(CustomAssetHandlerContext& ctx, DataContainer* container, WSTeamDataMergeData* data)
{
    WSTeamData* teamData = static_cast<WSTeamData*>(container);

    KYBER_LOG(Debug, "[ModLoader] Setting up new team kits");

    if (data->isAdded)
    {
        teamData->WSFaction = findDataContainer<WSFactionAsset>(ctx.runtimeDatabaseDomain, data->wsFaction, "WSTeamData/Faction");
        teamData->WSPlanetId = data->wsPlanetId;
    }

    IMPLEMENT_MERGE(WSSoldierCustomizationKitList, soldiers, Soldiers, SoldierIdCollection, TrooperClassIdCollection);
    IMPLEMENT_MERGE_AP(WSSoldierCustomizationKitList, apSoldiers, AutoPlayerSoldiers);

    IMPLEMENT_MERGE(WSSoldierCustomizationKitList, specialSoldiers, SpecialSoldiers, SpecialSoldiersIdCollection, SpecialClassIdCollection);
    IMPLEMENT_MERGE_AP(WSSoldierCustomizationKitList, apSpecialSoldiers, AutoPlayerSpecialSoldiers);

    IMPLEMENT_MERGE(WSSoldierCustomizationKitList, heroes, Heroes, HeroIdCollection, HeroClassIdCollection);
    IMPLEMENT_MERGE_AP(WSSoldierCustomizationKitList, apHeroes, AutoPlayerHeroes);

    IMPLEMENT_MERGE(WSVehicleCustomizationKitList, vehicles, Vehicles, VehicleIdCollection, VehicleClassIdCollection);
    IMPLEMENT_MERGE_AP(WSVehicleCustomizationKitList, apVehicles, AutoPlayerVehicles);

    IMPLEMENT_MERGE(WSVehicleCustomizationKitList, heroVehicles, HeroVehicles, HeroVehicleIdCollection, HeroVehicleClassIdCollection);
    IMPLEMENT_MERGE_AP(WSVehicleCustomizationKitList, apHeroVehicles, AutoPlayerHeroVehicles);

    if (!data->allPlayerAbilities.empty())
    {
        teamData->AllPlayerAbilities.init(data->allPlayerAbilities.size());

        for (int i = 0; i < data->allPlayerAbilities.size(); i++)
        {
            const auto& ref = data->allPlayerAbilities[i];
            Asset* ability = (Asset*)findDataContainer(ctx.runtimeDatabaseDomain, ref, "WSTeamData/Player Ability");
            teamData->AllPlayerAbilities.m_data[i] = ability;
        }
    }

    KYBER_LOG(Debug, "Done adding new team kits");
    return true;
}
} // namespace Kyber
