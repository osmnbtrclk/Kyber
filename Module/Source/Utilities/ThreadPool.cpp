// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <Utilities/ThreadPool.h>

namespace Kyber
{
ThreadPool::ThreadPool(int numThreads)
    : m_stop(false)
{
    for (int i = 0; i < numThreads; ++i)
    {
        m_workers.emplace_back([this] { WorkerThread(); });
    }
}

ThreadPool::~ThreadPool()
{
    {
        std::unique_lock<std::mutex> lock(m_queueMutex);
        m_stop = true;
    }

    m_condition.notify_all();

    for (std::thread& worker : m_workers)
    {
        worker.join();
    }
}

void ThreadPool::WorkerThread()
{
    while (true)
    {
        std::function<void()> task;

        {
            std::unique_lock<std::mutex> lock(m_queueMutex);
            m_condition.wait(lock, [this] { return m_stop || !m_tasks.empty(); });

            if (m_stop && m_tasks.empty())
            {
                return;
            }

            task = std::move(m_tasks.front());
            m_tasks.pop();
        }

        task();
    }
}
} // namespace Kyber
