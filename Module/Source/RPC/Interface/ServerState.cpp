// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#define _WINSOCKAPI_
#include <RPC/Interface/ServerState.h>

#include <Base/Log.h>
#include <Core/Program.h>
#include <Utilities/StringUtils.h>

#include <grpcpp/support/status.h>

namespace Kyber
{
using grpc::Status;

using namespace fastdelegate;
using namespace kyber_interface;

ServerUnaryReactor* ServerInterfaceService::StartServer(
    CallbackServerContext* context, const StartServerRequest* request, ServerState* response)
{
    ServerUnaryReactor* reactor = context->DefaultReactor();

    s_program->m_server->m_mapRotation.Reset();
    for (const auto& entry : request->maprotation())
    {
        s_program->m_server->m_mapRotation.AddEntry(entry.map(), entry.mode());
    }

    ServerCreationInfo info;
    info.name = request->name();
    info.description = request->description();
    info.password = request->password();

    auto entry = s_program->m_server->m_mapRotation.GetNextEntry();
    info.level = entry.level;
    info.mode = entry.mode;

    info.maxPlayers = request->maxplayers();

    s_program->m_server->Start(info);

    reactor->Finish(Status::OK);
    return reactor;
}

ServerUnaryReactor* ServerInterfaceService::LoadLevel(
    CallbackServerContext* context, const kyber_interface::LoadLevelRequest* request, kyber_common::Empty* response)
{
    KYBER_LOG(Info, "[Server] Loading remotely requested level");

    const auto& setup = request->levelsetup();
    s_program->m_server->LoadNextLevel(setup.map().c_str(), setup.mode().c_str());

    ServerUnaryReactor* reactor = context->DefaultReactor();
    reactor->Finish(Status::OK);
    return reactor;
}
} // namespace Kyber
