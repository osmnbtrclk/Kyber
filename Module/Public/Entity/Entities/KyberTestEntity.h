#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberTestEntityData : public EntityData
{
public:
    uint32_t TestField;
};

class KyberTestEntity : public KyberEntity<KyberTestEntityData>
{
public:
    KyberTestEntity(EntityManager* entityManager, NativeEntity* entity, KyberTestEntityData* data);

    void Event(EntityEvent* event) override;
};
} // namespace Kyber
