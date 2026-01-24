#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberVoipSettingsEntityData : public EntityData
{
public:
    float InputVolume;
    uint64_t PlayerId;
};

class KyberVoipSettingsEntity : public KyberEntity<KyberVoipSettingsEntityData>
{
public:
    KyberVoipSettingsEntity(EntityManager* entityManager, NativeEntity* entity, KyberVoipSettingsEntityData* data);

    void PropertyChanged(PropertyModification* modification) override;
};
} // namespace Kyber
