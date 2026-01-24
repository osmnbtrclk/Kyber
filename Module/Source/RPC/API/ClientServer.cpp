// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#define _WINSOCKAPI_
#include <RPC/API/ClientServer.h>

#include <Base/Log.h>

#include <future>

namespace Kyber
{
using grpc::ClientContext;
using grpc::Status;

ClientServerAPI::ClientServerAPI(std::shared_ptr<Channel> channel, std::string token)
    : m_stub(ClientServer::NewStub(channel))
    , m_threadPool(4)
    , m_token(token)
{}

void ClientServerAPI::ConsumeJoinToken(const std::string& serverId, const std::string& token,
    std::function<void(std::optional<const ConsumeJoinTokenResponse*>)> callback) const
{
    m_threadPool.Enqueue([this, serverId, token, callback = std::move(callback)]() mutable {
        ClientContext context;
        context.AddMetadata("authorization", m_token);

        ConsumeJoinTokenRequest request;
        request.set_token(token);
        request.set_server(serverId);

        ConsumeJoinTokenResponse response;
        Status status = m_stub->ConsumeJoinToken(&context, request, &response);
        if (!status.ok())
        {
            KYBER_LOG(Error, "[RPC] RPC error while consuming join token (" << status.error_message() << ")");
            callback(std::nullopt);
            return;
        }

        callback(&response);
    });
}
} // namespace Kyber
