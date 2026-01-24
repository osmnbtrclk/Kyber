// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <queue>
#include <mutex>
#include <optional>

namespace Kyber
{
template<class T>
class SafeQueue
{
public:
    void enqueue(T& val)
    {
        std::scoped_lock lock(m_mutex);
        m_queue.push(val);
    }

    std::optional<T> tryDequeue()
    {
        std::scoped_lock lock(m_mutex);
        if (m_queue.empty())
        {
            return std::nullopt;
        }

        T val = m_queue.front();
        m_queue.pop();
        return val;
    }

private:
    std::queue<T> m_queue;
    std::mutex m_mutex;
};
} // namespace Kyber