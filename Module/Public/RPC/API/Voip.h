// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Core/Server.h>
#include <Utilities/ThreadPool.h>

#include <Proto/kyber_api.grpc.pb.h>

#include <grpcpp/grpcpp.h>

#include <memory>
#include <string>

namespace Kyber
{
using namespace kyber_api;

using grpc::Channel;

class VoipAPI
{
public:
    VoipAPI(std::shared_ptr<Channel> channel, std::string token);

    void Login(std::function<void(std::optional<const VoipLoginResponse*>)> callback) const;
    void JoinChannel(const std::string& serverId, std::function<void(std::optional<const VoipJoinChannelResponse*>)> callback) const;

private:
    std::shared_ptr<Voip::Stub> m_stub;
    mutable ThreadPool m_threadPool;

    std::string m_token;
};
} // namespace Kyber
