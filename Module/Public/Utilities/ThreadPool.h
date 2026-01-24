// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <vector>
#include <thread>
#include <mutex>
#include <queue>
#include <functional>
#include <condition_variable>
#include <future>

#include <Utilities/ErrorUtils.h>

namespace Kyber
{
class ThreadPool
{
public:
    ThreadPool(int numThreads);
    ~ThreadPool();

    template <typename F, typename... Args>
    void Enqueue(F&& f, Args&&... args);

private:
    void WorkerThread();

    std::vector<std::thread> m_workers;
    std::queue<std::function<void()>> m_tasks;

    std::mutex m_queueMutex;
    std::condition_variable m_condition;
    bool m_stop;
};

template <typename F, typename... Args>
void ThreadPool::Enqueue(F&& f, Args&&... args)
{
    auto task = std::make_shared<std::packaged_task<void()>>(std::bind(std::forward<F>(f), std::forward<Args>(args)...));

    {
        std::unique_lock<std::mutex> lock(m_queueMutex);

        if (m_stop)
        {
            ErrorUtils::ThrowException("Enqueue on stopped ThreadPool");
        }

        m_tasks.emplace([task]() { (*task)(); });
    }

    m_condition.notify_one();
}
} // namespace Kyber