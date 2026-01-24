// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Overrides/PrintDebugTextEntity.h>

#include <Entity/KyberSettings.h>
#include <Core/Program.h>

namespace Kyber
{
KB_IMPLEMENT_ENTITY_OVERRIDE(PrintDebugTextEntity, PrintDebugTextEntityData);

PrintDebugTextEntity::PrintDebugTextEntity(EntityManager* entityManager, NativeEntity* entity, PrintDebugTextEntityData* data)
    : KyberEntity(entity, data)
    , m_enabled(data->Enabled)
{
    m_text = data->Text;
}

void PrintDebugTextEntity::Event(EntityEvent* event)
{
    if (!m_enabled)
    {
        return;
    }

    std::string text = m_text;

    auto field = GetFieldReader<char*>("Text");
    if (field.HasConnectionValue())
    {
        text = field.Get();
    }

    KYBER_LOG(Debug, "[PrintDebugText] " << m_text);
}
} // namespace Kyber
