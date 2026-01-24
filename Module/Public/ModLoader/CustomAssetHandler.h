// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Network/SocketManager.h>
#include <SDK/TypeInfo.h>
#include <ModLoader/KyberMod.h>

#include <frosty_mod.h>
#include <parse_common.h>

#include <ByteBuffer/ByteBuffer.hpp>

namespace Kyber
{
DataContainer* findDataContainer(void* domain, const EbxImportReference& ref, const char* tag);

template<typename T>
T* findDataContainer(void* domain, const EbxImportReference& ref, const char* tag)
{
    return reinterpret_cast<T*>(findDataContainer(domain, ref, tag));
}

// Parses the instance, then partition GUIDs
EbxImportReference parseReference(bb::ByteBuffer& buf);

// Parses the partition, then instance GUIDs
EbxImportReference parseReference2(bb::ByteBuffer& buf);

struct CustomAssetHandlerContext
{
    void* runtimeDatabaseDomain;
    bool clearRequired;
};

struct CustomAssetHandlerData
{
    virtual ~CustomAssetHandlerData() = default;
};

enum CustomAssetHandlerLoadStage
{
    CustomAssetHandlerLoadStage_ReferencesResolved,
    CustomAssetHandlerLoadStage_PostLoad,
};

class CustomAssetHandler
{
public:
    CustomAssetHandler(CustomAssetHandlerLoadStage loadStage);
    virtual ~CustomAssetHandler() = default;

    virtual CustomAssetHandlerData* Create() = 0;
    virtual void Load(const eastl::string& modName, bb::ByteBuffer& buf, CustomAssetHandlerData* data) = 0;
    virtual void PreModify(EbxPartitionReader& reader, CustomAssetHandlerData* data) = 0;
    virtual bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, CustomAssetHandlerData* data) = 0;

    CustomAssetHandlerLoadStage GetLoadStage() const
    {
        return m_loadStage;
    }

private:
    CustomAssetHandlerLoadStage m_loadStage;
};

template<typename T>
class GenericCustomAssetHandler : public CustomAssetHandler
{
public:
    GenericCustomAssetHandler(CustomAssetHandlerLoadStage loadStage)
        : CustomAssetHandler(loadStage)
    {}

    virtual void Load(const eastl::string& modName, bb::ByteBuffer& buf, T* data) = 0;
    virtual void PreModify(EbxPartitionReader& reader, T* data) {}
    virtual bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, T* data) = 0;

    CustomAssetHandlerData* Create() override
    {
        return new T();
    }

    void Load(const eastl::string& modName, bb::ByteBuffer& buf, CustomAssetHandlerData* data) override
    {
        Load(modName, buf, dynamic_cast<T*>(data));
    }

    void PreModify(EbxPartitionReader& reader, CustomAssetHandlerData* data) override
    {
        PreModify(reader, dynamic_cast<T*>(data));
    }

    bool Modify(CustomAssetHandlerContext& ctx, DataContainer* container, CustomAssetHandlerData* data) override
    {
        return Modify(ctx, container, dynamic_cast<T*>(data));
    }
};
} // namespace Kyber
