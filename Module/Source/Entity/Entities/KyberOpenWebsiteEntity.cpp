// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Entities/KyberOpenWebsiteEntity.h>

#include <shellapi.h>

namespace Kyber
{
KB_IMPLEMENT_TYPE(KyberOpenWebsiteEntityData)
{
    KyberTypeInfo info("KyberOpenWebsiteEntityData", "EntityData");
    info.AddField("CString", "URL");
    return info;
}

KB_IMPLEMENT_ENTITY(KyberOpenWebsiteEntity, KyberOpenWebsiteEntityData);

KyberOpenWebsiteEntity::KyberOpenWebsiteEntity(EntityManager* entityManager, NativeEntity* entity, KyberOpenWebsiteEntityData* data)
    : KyberEntity(entity, data)
{}

void KyberOpenWebsiteEntity::Event(EntityEvent* event)
{
    if (event->Is("Open"))
    {
        std::string url = GetData()->URL;
        if (!url.starts_with("https://kyber.gg") && !url.starts_with("https://nexusmods.com") &&
            !url.starts_with("https://www.nexusmods.com") && !url.starts_with("https://battlefront.plus"))
        {
            KYBER_LOG(Warning,
                "Attempted to open suspicious URL: "
                    << url << ". KyberOpenWebsiteEntity only accepts URLs starting with 'https://kyber.gg', 'https://nexusmods.com', 'https://www.nexusmods.com', or 'https://battlefront.plus'.");
            return;
        }

        ShellExecute(0, 0, url.c_str(), 0, 0, SW_SHOW);
    }
}
} // namespace Kyber
