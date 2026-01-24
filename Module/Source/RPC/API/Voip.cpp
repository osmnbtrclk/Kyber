// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#define _WINSOCKAPI_
#include <RPC/API/Voip.h>

#include <Base/Log.h>

namespace Kyber
{
using grpc::ClientContext;
using grpc::Status;

VoipAPI::VoipAPI(std::shared_ptr<Channel> channel, std::string token)
    : m_stub(Voip::NewStub(channel))
    , m_threadPool(1)
    , m_token(token)
{}

void VoipAPI::Login(std::function<void(std::optional<const VoipLoginResponse*>)> callback) const
{
    m_threadPool.Enqueue([this, callback = std::move(callback)]() mutable {
        ClientContext context;
        context.AddMetadata("authorization", m_token);

        kyber_common::Empty empty;

        VoipLoginResponse response;
        Status status = m_stub->Login(&context, empty, &response);
        if (!status.ok())
        {
            KYBER_LOG(Error, "[RPC] RPC error while logging into VOIP (" << status.error_message() << ")");
            callback(std::nullopt);
            return;
        }

        callback(&response);
    });
}

void VoipAPI::JoinChannel(const std::string& serverId, std::function<void(std::optional<const VoipJoinChannelResponse*>)> callback) const
{
    m_threadPool.Enqueue([this, serverId, callback = std::move(callback)]() mutable {
        ClientContext context;
        context.AddMetadata("authorization", m_token);

        VoipJoinChannelRequest request;
        request.set_server(serverId);

        VoipJoinChannelResponse response;
        Status status = m_stub->JoinChannel(&context, request, &response);
        if (!status.ok())
        {
            KYBER_LOG(Error, "[RPC] RPC error while joining VOIP channel (" << status.error_message() << ")");
            callback(std::nullopt);
            return;
        }

        callback(&response);
    });
}
} // namespace Kyber
