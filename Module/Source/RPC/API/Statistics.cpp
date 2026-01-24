// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#define _WINSOCKAPI_
#include <RPC/API/Statistics.h>

#include <Base/Log.h>

namespace Kyber
{
using grpc::ClientContext;
using grpc::Status;

StatisticsAPI::StatisticsAPI(std::shared_ptr<Channel> channel, std::string token)
    : m_stub(Statistics::NewStub(channel))
    , m_threadPool(4)
    , m_token(token)
{}

std::map<std::string, float> convertProtoToStdMap(const google::protobuf::Map<std::string, float>& protoMap)
{
    std::map<std::string, float> map;
    for (const auto& pair : protoMap)
    {
        map[pair.first] = pair.second;
    }
    return map;
}

void StatisticsAPI::GetStats(
    StatsSource source, const std::string& userId, std::function<void(std::optional<PlayerStatsMap>)> callback) const
{
    m_threadPool.Enqueue([this, source, userId, callback = std::move(callback)]() mutable {
        ClientContext context;

        StatsRequest request;
        request.set_source(source);
        request.set_user(userId);

        StatsResponse response;
        Status status = m_stub->GetStats(&context, request, &response);
        if (!status.ok())
        {
            KYBER_LOG(Error, "[RPC] RPC error while retrieving stats (" << status.error_message() << ")");
            callback(std::nullopt);
            return;
        }

        callback(convertProtoToStdMap(response.stats()));
    });
}

void StatisticsAPI::UpdateStats(StatsSource source, const std::string& userId, const PlayerStatsMap& stats) const
{
    m_threadPool.Enqueue([this, source, userId, stats]() mutable {
        ClientContext context;
        context.AddMetadata("authorization", m_token);

        UpdateStatsRequest request;
        request.set_source(source);
        request.set_user(userId);
        google::protobuf::Map<std::string, float>& protoMap = *request.mutable_stats();

        for (const auto& pair : stats)
        {
            protoMap[pair.first] = pair.second;
        }

        kyber_common::Empty response;
        Status status = m_stub->UpdateStats(&context, request, &response);
        if (!status.ok())
        {
            KYBER_LOG(Error, "[RPC] RPC error while updating stats (" << status.error_message() << ")");
        }
    });
}
} // namespace Kyber
