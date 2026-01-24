// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <typeinfo>

namespace Kyber
{
class Event
{
public:
    virtual ~Event() = default;

    template<typename T>
    bool is() const
    {
        return typeid(T) == typeid(*this);
    }

    template<typename T>
    const T& as() const
    {
        return static_cast<const T&>(*this);
    }
};
} // namespace Kyber
