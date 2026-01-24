#pragma once

#include <SDK/TypeInfo.h>

#include <EASTL/map.h>
#include <EASTL/unordered_set.h>

namespace Kyber
{
class CustomResourceHandler
{
public:
    CustomResourceHandler();
    virtual ~CustomResourceHandler() = default;

    virtual CustomResourceHandler* Create() = 0;
    virtual void Load(const eastl::string& modName, bb::ByteBuffer& buf, CustomResourceHandler* data) = 0;
    virtual bool Modify(void* ctx, DataContainer* container, CustomResourceHandler* data) = 0;
};

class ResourceMerger
{
public:
    ResourceMerger();

    void onResourceManagerInitialized();
};
} // namespace Kyber
