#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class TestCaseEntity : public KyberEntity<TestCaseEntityData>
{
public:
    TestCaseEntity(EntityManager* entityManager, NativeEntity* entity, TestCaseEntityData* data);
    ~TestCaseEntity();

    std::string GetName() const { return GetData()->TestCaseName; }
};
} // namespace Kyber
