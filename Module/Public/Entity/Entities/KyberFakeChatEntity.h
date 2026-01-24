#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberFakeChatEntityData : public EntityData
{
public:
    const char* Name;
    const char* Message;
    ChatChannel Channel;
};

class KyberFakeChatEntity : public KyberEntity<KyberFakeChatEntityData>
{
public:
    KyberFakeChatEntity(EntityManager* entityManager, NativeEntity* entity, KyberFakeChatEntityData* data);

    void Event(EntityEvent* event) override;

private:
    std::string GetField(const char* fieldName) const;
};
} // namespace Kyber
