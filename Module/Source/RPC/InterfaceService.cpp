#include <RPC/InterfaceService.h>

#include <Base/Log.h>

#include <memory>

#include <fmt/args.h>

namespace Kyber
{
InterfaceService::InterfaceService()
{
    grpc::ServerBuilder builder;

    const char* portOverride = std::getenv("KYBER_INTERFACE_PORT");
    int port = portOverride != nullptr ? atoi(portOverride) : 3005;

    std::string serverAddress = fmt::format("0.0.0.0:{}", port);
    builder.AddListeningPort(serverAddress, grpc::InsecureServerCredentials());

    m_clientState = std::make_unique<ClientInterfaceService>();
    builder.RegisterService(m_clientState.get());

    m_serverState = std::make_unique<ServerInterfaceService>();
    builder.RegisterService(m_serverState.get());

    m_common = std::make_unique<CommonInterfaceService>();
    builder.RegisterService(m_common.get());

    m_server = builder.BuildAndStart();

    KYBER_LOG(Info, "[RPC] Started interface server on port " << port);
}
} // namespace Kyber
