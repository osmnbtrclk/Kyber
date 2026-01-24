#pragma once

#include <Entity/NativeEntityManager.h>

#include <Core/DebugHooks.h>

namespace Kyber
{
class PrintDebugTextEntity : public KyberEntity<PrintDebugTextEntityData>
{
public:
    PrintDebugTextEntity(EntityManager* entityManager, NativeEntity* entity, PrintDebugTextEntityData* data);

    void Event(EntityEvent* event) override;

private:
    bool m_enabled;

    std::string m_text;
};
} // namespace Kyber
