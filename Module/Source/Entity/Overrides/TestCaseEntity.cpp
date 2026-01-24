// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Entity/Overrides/TestCaseEntity.h>

#include <Entity/KyberSettings.h>
#include <Core/Program.h>

namespace Kyber
{
class TestCaseManager
{
public:
    TestCaseManager()
    {
        auto delegate = fastdelegate::MakeDelegate(this, &TestCaseManager::List);
        ConsoleRegistry_registerInstanceMethod(delegate, "List", "TestCase");
    }

    ~TestCaseManager()
    {
        //KYBER_LOG(Info, "Destroyed OBB Collision manager");
    }
    
    void List(ConsoleContext& cc)
    {
        for (auto entity : m_entities)
        {
            std::string name = entity->GetName();
            cc << name << "\n";
        }
    }

    bool Empty() const
    {
        return m_entities.empty();
    }

    void Register(TestCaseEntity* entity)
    {
        m_entities.push_back(entity);
    }

    void Unregister(TestCaseEntity* entity)
    {
        m_entities.erase(std::remove(m_entities.begin(), m_entities.end(), entity), m_entities.end());
    }

private:
    eastl::vector<TestCaseEntity*> m_entities;
};

static TestCaseManager* s_manager;

KB_IMPLEMENT_ENTITY_OVERRIDE(TestCaseEntity, TestCaseEntityData);
KB_IMPLEMENT_ENTITY_OVERRIDE(TestCaseEntity, WSTestCaseEntityData);

TestCaseEntity::TestCaseEntity(EntityManager* entityManager, NativeEntity* entity, TestCaseEntityData* data)
    : KyberEntity(entity, data)
{
    if (s_manager == nullptr)
    {
        s_manager = new TestCaseManager();
    }

    s_manager->Register(this);
}

TestCaseEntity::~TestCaseEntity()
{
    s_manager->Unregister(this);

    if (s_manager->Empty())
    {
        delete s_manager;
        s_manager = nullptr;
    }
}
} // namespace Kyber
