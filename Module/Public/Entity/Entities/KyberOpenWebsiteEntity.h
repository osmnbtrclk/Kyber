#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberOpenWebsiteEntityData : public EntityData
{
public:
    char* URL;
};

class KyberOpenWebsiteEntity : public KyberEntity<KyberOpenWebsiteEntityData>
{
public:
    KyberOpenWebsiteEntity(EntityManager* entityManager, NativeEntity* entity, KyberOpenWebsiteEntityData* data);

    void Event(EntityEvent* event) override;
};
} // namespace Kyber
