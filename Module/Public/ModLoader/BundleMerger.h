#pragma once

#include <SDK/TypeInfo.h>
#include <ModLoader/DbObject.h>
#include <ModLoader/ManifestMerger.h>

#include <cstdint>
#include <vector>
#include <string>
#include <functional>

#include <EASTL/unordered_map.h>

namespace Kyber
{
class BundleManifest
{
public:
    struct EbxEntry
    {
        std::string name;
        uint32_t originalSize;
    };

    struct ResEntry : EbxEntry
    {
        uint32_t resType;
        uint8_t resMeta[0x10];
        uint64_t resRid;
    };

    struct ChunkEntry
    {
        Guid guid;
        uint32_t logicalOffset;
        uint32_t logicalSize;
    };

    enum Result
    {
        Rt_Nop,
        Rt_Modified,
        Rt_Added
    };

    BundleManifest() = default;

    void Load(uint8_t* data, uint32_t size);
    std::vector<uint8_t> Save();

    void Clear();

    void ModifyEbxEntry(const eastl::string& name, uint32_t originalSize);
    void ModifyResEntry(const ResEntry& entry);

    Result AddEbxEntry(eastl::string name, uint32_t originalSize, bool allowModify = true);
    Result AddResEntry(ResEntry entry, bool allowModify = true);
    Result AddChunkEntry(ChunkEntry entry, int32_t h32, int32_t firstMip, bool allowNew = true, bool allowModify = true);

    void PushAudit(const eastl::string& log);

    const eastl::vector<eastl::string>& GetAuditLog() const
    {
        return m_auditLog;
    }

private:
    int32_t GetMetaIndex(int32_t h32) const;

    uint32_t m_totalCount;
    uint32_t m_ebxCount;
    uint32_t m_resCount;
    uint32_t m_chunkCount;
    uint32_t m_stringsOffset;
    uint32_t m_metaOffset;
    uint32_t m_metaSize;

    eastl::vector<EbxEntry> m_ebxEntries;
    eastl::vector<ResEntry> m_resEntries;
    eastl::vector<ChunkEntry> m_chunkEntries;

    std::shared_ptr<DbObject> m_meta;

    eastl::vector<eastl::string> m_auditLog;
};

typedef std::function<void(BundleManifest& manifest)> BundleMergeFunc;

class BundleMerger
{
public:
    struct BundleEntry
    {
        uint32_t hash;
        uint32_t ebxCount;
        uint32_t resCount;
        uint32_t chunkCount;
        std::vector<LayoutManifest::FileInfo> files;
    };

    struct VanillaEbxEntry
    {
        BundleManifest::EbxEntry entry;
        LayoutManifest::FileInfo file;
        eastl::map<uint32_t, uint32_t> bundleFileOffsets;
    };

    struct VanillaResEntry
    {
        BundleManifest::ResEntry entry;
        LayoutManifest::FileInfo file;
        eastl::map<uint64_t, uint32_t> bundleFileOffsets;
    };

    struct VanillaChunkEntry
    {
        BundleManifest::ChunkEntry entry;
        LayoutManifest::FileInfo file;
        int32_t h32;
        int32_t firstMip;
        eastl::map<uint64_t, uint32_t> bundleFileOffsets;
    };

    BundleMerger();

    void SetMerger(BundleMergeFunc func);
    void Merge(BundleManifest& manifest);

    bool HasMerger() const
    {
        return m_merger != nullptr;
    }

    void LoadVanillaEntries();
    
    uint32_t GetCatalogCount() const
    {
        return m_catalogs.size();
    }

    const eastl::string& GetCatalog(uint32_t index) const
    {
        return m_catalogs.at(index);
    }

    std::unordered_map<uint32_t, BundleEntry>& GetBundleEntries();

    VanillaEbxEntry* GetVanillaEbxEntry(const eastl::string& name);
    VanillaResEntry* GetVanillaResEntry(const eastl::string& name);
    VanillaChunkEntry* GetVanillaChunkEntry(const eastl::string& name);

private:
    BundleMergeFunc m_merger;

    eastl::vector<eastl::string> m_catalogs;

    // Hash, Entry
    std::unordered_map<uint32_t, BundleEntry> m_bundleEntries;

    // Name, Original size
    std::map<std::string, VanillaEbxEntry> m_vanillaEbxEntries;
    std::map<std::string, VanillaResEntry> m_vanillaResEntries;
    std::map<std::string, VanillaChunkEntry> m_vanillaChunkEntries;
};

extern BundleMerger* g_bundleMerger;
} // namespace Kyber
