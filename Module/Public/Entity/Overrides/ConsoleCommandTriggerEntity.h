// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Entity/NativeEntityManager.h>

#include <Core/DebugHooks.h>
#include <Core/Console.h>

namespace Kyber
{
class ConsoleCommandTriggerEntity : public KyberEntity<ConsoleCommandTriggerEntityData>
{
public:
    ConsoleCommandTriggerEntity(EntityManager* entityManager, NativeEntity* entity, ConsoleCommandTriggerEntityData* data);
    ~ConsoleCommandTriggerEntity();

    void Execute(ConsoleContext& cc);
    void Update(const UpdateParameters& params) override;

private:
    std::string m_name;

    int m_commandCount;
};
} // namespace Kyber
