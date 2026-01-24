// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Entities/KyberTestEntity.h>

namespace Kyber
{
KB_IMPLEMENT_TYPE(KyberTestEntityData)
{
    KyberTypeInfo info("KyberTestEntityData", "EntityData");
    info.AddField("Uint32", "TestField");
    return info;
}

KB_IMPLEMENT_ENTITY(KyberTestEntity, KyberTestEntityData);

KyberTestEntity::KyberTestEntity(EntityManager* entityManager, NativeEntity* entity, KyberTestEntityData* data)
    : KyberEntity(entity, data)
{
    KYBER_LOG(Info, "Test field: " << data->TestField);
}

void KyberTestEntity::Event(EntityEvent* event)
{
    FireEvent(event->eventId);
}
} // namespace Kyber
