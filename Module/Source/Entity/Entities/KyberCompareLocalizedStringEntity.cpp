// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Entities/KyberCompareLocalizedStringEntity.h>

#include <Core/Program.h>
#include <SDK/Funcs.h>

namespace Kyber
{
KB_IMPLEMENT_TYPE(KyberCompareLocalizedStringEntityData)
{
    KyberTypeInfo info("KyberCompareLocalizedStringEntityData", "CompareEntityBaseData");
    info.AddField("CString", "A");
    info.AddField("CString", "B");
    return info;
}

KB_IMPLEMENT_ENTITY(KyberCompareLocalizedStringEntity, KyberCompareLocalizedStringEntityData);

KyberCompareLocalizedStringEntity::KyberCompareLocalizedStringEntity(EntityManager* entityManager, NativeEntity* entity, KyberCompareLocalizedStringEntityData* data)
    : KyberEntity(entity, data)
{}

void KyberCompareLocalizedStringEntity::Event(EntityEvent* event)
{
    if (event->eventId == StringUtils::HashQuick("In"))
    {
        DoComparison();
    }
}

void KyberCompareLocalizedStringEntity::PropertyChanged(PropertyModification* modification)
{
    if (!GetData()->TriggerOnPropertyChange)
    {
        return;
    }

    DoComparison();
}

void KyberCompareLocalizedStringEntity::DoComparison()
{
    auto aField = GetFieldReader<char*>("A");
    auto bField = GetFieldReader<char*>("B");

    std::string a = aField.HasConnection() && aField.HasConnectionValue() ? aField.Get() : GetData()->A;
    std::string b = bField.HasConnection() && bField.HasConnectionValue() ? bField.Get() : GetData()->B;

    const char* localizedA = LocalizationManager_getString(a.c_str(), false);
    const char* localizedB = LocalizationManager_getString(b.c_str(), false);

    if (localizedA == nullptr || localizedB == nullptr)
    {
        KYBER_LOG(Error, "Failed to localize strings for comparison, ensure the IDs are correct");
        FireEvent("OnFalse");
        return;
    }

    if (strcmp(localizedA, localizedB) == 0)
    {
        FireEvent("OnTrue");
    }
    else
    {
        FireEvent("OnFalse");
    }
}
} // namespace Kyber
