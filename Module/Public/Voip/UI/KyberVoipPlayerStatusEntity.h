#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberVoipPlayerStatusEntityData : public EntityData
{
public:
    char* PlayerName;
};

class KyberVoipPlayerStatusEntity : public KyberEntity<KyberVoipPlayerStatusEntityData>
{
public:
    KyberVoipPlayerStatusEntity(EntityManager* entityManager, NativeEntity* entity, KyberVoipPlayerStatusEntityData* data);

    void Update(const UpdateParameters& params) override;

private:
    PropertyWriter<bool> m_isPlayerTalking;
};
} // namespace Kyber
