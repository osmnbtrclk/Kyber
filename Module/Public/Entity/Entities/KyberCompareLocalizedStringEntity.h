#pragma once

#include <Entity/NativeEntityManager.h>

namespace Kyber
{
class KyberCompareLocalizedStringEntityData : public CompareEntityBaseData
{
public:
    const char* A;
    const char* B;
};

class KyberCompareLocalizedStringEntity : public KyberEntity<KyberCompareLocalizedStringEntityData>
{
public:
    KyberCompareLocalizedStringEntity(EntityManager* entityManager, NativeEntity* entity, KyberCompareLocalizedStringEntityData* data);

    void Event(EntityEvent* event) override;
    void PropertyChanged(PropertyModification* modification) override;

private:
    void DoComparison();
};
} // namespace Kyber
