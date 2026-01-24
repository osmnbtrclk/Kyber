// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Overrides/WSPrintDebugTextEntity.h>

#include <Entity/KyberSettings.h>
#include <Core/Program.h>

namespace Kyber
{
KB_IMPLEMENT_ENTITY_OVERRIDE(WSPrintDebugTextEntity, WSPrintDebugTextEntityData);

WSPrintDebugTextEntity::WSPrintDebugTextEntity(EntityManager* entityManager, NativeEntity* entity, WSPrintDebugTextEntityData* data)
    : KyberEntity(entity, data)
    , m_subName(data->SubName)
{}

void WSPrintDebugTextEntity::Event(EntityEvent* event)
{
    for (const auto& e : GetData()->Events)
    {
        if (e.NameHash != event->eventId)
        {
            continue;
        }

        std::string s = "[WSPrintDebugText] ";
        if (!m_subName.empty())
        {
            s += m_subName;
        }
        s += e.Name;

        KYBER_LOG(Debug, s);
        break;
    }
}
} // namespace Kyber
