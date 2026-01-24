#pragma once

#include <SDK/TypeInfo.h>

#include <cstdint>
#include <vector>
#include <functional>

#include <EASTL/map.h>
#include <EASTL/unordered_set.h>

namespace Kyber
{
class LayoutManifest
{
public:
    enum AssetType
    {
        Ebx,
        Res,
        Chunk
    };

    struct FileInfo
    {
        int32_t file;
        uint32_t offset;
        int64_t size;

        std::string ToString() const
        {
            return "{file: " + std::to_string(file) + ", offset: " + std::to_string(offset) + ", size: " + std::to_string(size) + "}";
        }
    };

    struct BundleInfo
    {
        uint32_t hash;
        std::vector<FileInfo> files;
        int32_t unk1;
        int32_t unk2;
    };

    struct ChunkInfo
    {
        Guid guid;
        int32_t fileIndex;
        FileInfo file;
    };

    using AuditLog = eastl::map<int32_t, eastl::vector<eastl::string>>;

    LayoutManifest() = default;

    void Load(uint8_t* data, uint32_t size);
    std::vector<uint8_t> Save();

    void AddFileToBundle(uint32_t bundleHash, FileInfo fileInfo, AssetType assetType);
    void SetFileInfo(uint32_t bundleHash, int index, FileInfo fileInfo);

    FileInfo* GetChunk(const Guid& guid);
    void AddChunk(const Guid& guid, FileInfo fileInfo);

    const eastl::map<uint32_t, BundleInfo>& GetBundleInfo()
    {
        return m_bundleInfo;
    }

    void AddBundle(uint32_t hash);

    void PushAudit(uint32_t bundleHash, const eastl::string& log);
    void PrintAudit(uint32_t bundleHash);

    const AuditLog& GetAuditLog() const
    {
        return m_auditLog;
    }

private:
    eastl::vector<FileInfo> m_fileInfo;
    eastl::map<uint32_t, BundleInfo> m_bundleInfo;

    eastl::map<Guid, ChunkInfo> m_chunkGuids;

    AuditLog m_auditLog;
};

typedef std::function<void(LayoutManifest& manifest)> ManifestMergeFunc;

class ManifestMerger
{
public:
    ManifestMerger();

    void SetMerger(ManifestMergeFunc func);
    void Merge(LayoutManifest& manifest);

    bool HasMerger() const
    {
        return m_merger != nullptr;
    }

    LayoutManifest* GetLastManifest() const
    {
        return m_lastManifest;
    }

private:
    ManifestMergeFunc m_merger;
    LayoutManifest* m_lastManifest;
};

extern ManifestMerger* g_manifestMerger;
} // namespace Kyber
