// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Core/Event.h>

#include <queue>
#include <typeindex>
#include <unordered_map>
#include <vector>
#include <mutex>

namespace Kyber
{
class EventListener
{
public:
    virtual ~EventListener() = default;
    virtual void OnEvent(const Event& event) = 0;
};

class EventManager
{
public:
    void RegisterListener(std::type_index eventType, EventListener* listener)
    {
        m_listeners[eventType].push_back(listener);
    }

    template<typename T>
    void RegisterListener(EventListener* listener)
    {
        RegisterListener(std::type_index(typeid(T)), listener);
    }

    void UnregisterListeners(EventListener* listener);

    void QueueEvent(const Event* event)
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        m_eventQueue.push(event);
    }

    void ProcessEventQueue();
    void DispatchEvent(const Event& event);

private:
    std::mutex m_mutex;

    std::unordered_map<std::type_index, std::vector<EventListener*>> m_listeners;
    std::queue<const Event*> m_eventQueue;
};
} // namespace Kyber