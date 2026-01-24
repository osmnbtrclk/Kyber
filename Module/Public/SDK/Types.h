// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <cstdint>

namespace Kyber
{
#define KB_UNIMPLEMENTED do { KYBER_LOG(Error, __FUNCTION__ << " is unimplemented"); exit(1); } while (false)

enum ClientUpdatePass
{
    ClientUpdatePass_PreFrame,
    ClientUpdatePass_Online,
    ClientUpdatePass_PostFrame,
};

class ClientUpdatePassListener
{
public:
    virtual ~ClientUpdatePassListener() = default;
    virtual void Call(ClientUpdatePass pass) = 0;
};

struct TimeSpan
{
    int64_t internal;

    float toSecondsAsFloat() const;
};

inline float TimeSpan::toSecondsAsFloat() const
{
    return float(double(internal)) * 0.000000001;
}

struct UpdateParameters
{
    TimeSpan simulationDeltaTime;
    TimeSpan simulationDeltaTimeUnscaled;
    TimeSpan wallDeltaTime;
};
} // namespace Kyber
