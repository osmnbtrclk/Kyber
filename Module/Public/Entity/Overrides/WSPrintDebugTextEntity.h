#pragma once

#include <Entity/NativeEntityManager.h>

#include <Core/DebugHooks.h>

namespace Kyber
{
class WSPrintDebugTextEntity : public KyberEntity<WSPrintDebugTextEntityData>
{
public:
    WSPrintDebugTextEntity(EntityManager* entityManager, NativeEntity* entity, WSPrintDebugTextEntityData* data);

    void Event(EntityEvent* event) override;

private:
    std::string m_subName;
};
} // namespace Kyber
