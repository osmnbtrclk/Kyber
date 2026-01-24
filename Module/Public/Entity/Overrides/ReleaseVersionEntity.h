#pragma once

#include <Entity/NativeEntityManager.h>

#include <Core/DebugHooks.h>

namespace Kyber
{
class ReleaseVersionEntity : public KyberEntity<ReleaseVersionEntityData>
{
public:
    ReleaseVersionEntity(EntityManager* entityManager, NativeEntity* entity, ReleaseVersionEntityData* data);

private:
    bool m_active;
};
} // namespace Kyber
