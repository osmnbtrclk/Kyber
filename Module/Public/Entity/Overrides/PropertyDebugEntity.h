#pragma once

#include <Entity/NativeEntityManager.h>

#include <Core/DebugHooks.h>

namespace Kyber
{
class PropertyDebugEntity : public KyberEntity<PropertyDebugEntityData>
{
public:
    PropertyDebugEntity(EntityManager* entityManager, NativeEntity* entity, PropertyDebugEntityData* data);

    void Event(EntityEvent* event) override;
    void Update(const UpdateParameters& params) override;

private:
    bool m_visible;
    std::string m_str;
};
} // namespace Kyber
