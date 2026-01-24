// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

namespace Kyber
{
class UDPSocket;

class SocketCreator
{
public:
    virtual void Close(UDPSocket* socket) = 0;
};

enum class ProtocolDirection
{
    Serverbound,
    Clientbound
};
} // namespace Kyber