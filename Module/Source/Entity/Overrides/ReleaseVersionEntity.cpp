// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Overrides/ReleaseVersionEntity.h>

#include <Entity/KyberSettings.h>
#include <Core/Program.h>

namespace Kyber
{
static const ReleaseVersion version = ReleaseVersion_Mainline;

KB_IMPLEMENT_ENTITY(ReleaseVersionEntity, ReleaseVersionEntityData);

ReleaseVersionEntity::ReleaseVersionEntity(EntityManager* entityManager, NativeEntity* entity, ReleaseVersionEntityData* data)
    : KyberEntity(entity, data)
    , m_active(false)
{
    for (const auto& v : data->IncludedInVersions)
    {
        if (v != version)
        {
            continue;
        }

        m_active = true;
        break;
    }

    KYBER_LOG(Debug, "Created release version entity " << data->IncludedInVersions.size() << " " << m_active);
    WriteField("Active", entityManager->GetNativeType("Boolean"), &m_active);
}
} // namespace Kyber
