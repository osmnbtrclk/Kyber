// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#include <optional>
#define _WINSOCKAPI_
#include <RPC/API/Launcher.h>

#include <Base/Log.h>
#include <Core/Program.h>

namespace Kyber
{
using grpc::ClientContext;
using grpc::Status;

LauncherInterface::LauncherInterface(std::shared_ptr<Channel> channel)
    : m_stub(LauncherCommon::NewStub(channel))
{}

void LauncherInterface::Initialize() const
{
    KYBER_LOG(Info, "[RPC] Asking launcher for initialization...");

    ClientContext context;

    kyber_common::Empty empty;

    InitializeRequest request;
    Status status = m_stub->Initialize(&context, empty, &request);
    if (!status.ok())
    {
        KYBER_LOG(Error, "[RPC] RPC error while initializing (" << status.error_message() << ")");
        return;
    }

    KYBER_LOG(Info, "[RPC] Initializing from launcher");
    s_program->Initialize();

    switch (request.startState_case())
    {
    case kyber_interface::InitializeRequest::kStartServer: {
        const auto& server = request.startserver();

        s_program->m_server->m_mapRotation.Reset();
        for (const auto& entry : server.maprotation())
        {
            s_program->m_server->m_mapRotation.AddEntry(entry.map(), entry.mode());
        }

        ServerCreationInfo info;
        info.name = server.name();
        info.description = server.description();
        info.password = server.password();

        auto entry = s_program->m_server->m_mapRotation.GetNextEntry();
        info.level = entry.level;
        info.mode = entry.mode;

        info.maxPlayers = server.maxplayers();

        info.loadCommands.reserve(request.startupcommands_size());
        for (const auto& command : request.startupcommands())
        {
            info.loadCommands.push_back(command);
        }

        auto* event = new MainLoopInitStartServerEvent();
        event->info = info;
        s_program->m_server->m_mainLoopInitEventManager->QueueEvent(event);
        break;
    }
    case kyber_interface::InitializeRequest::kJoinServer: {
        const auto& joinServer = request.joinserver();

        auto* event = new MainLoopInitJoinServerEvent();
        event->id = joinServer.id();
        event->ip = joinServer.ip();
        event->port = joinServer.port();
        event->spectate = joinServer.spectate();
        event->proxied = joinServer.type() == kyber_interface::JoinServerType::PROXIED;
        event->password = "";
        s_program->m_joinToken = joinServer.jointoken();
        s_program->m_server->m_mainLoopInitEventManager->QueueEvent(event);
        break;
    }
    case kyber_interface::InitializeRequest::STARTSTATE_NOT_SET:
        break;
    }

    if (request.has_moddata())
    {
        ModData modData{};
        modData.basePath = request.moddata().basepath();

        modData.modPaths.reserve(request.moddata().modpaths_size());
        for (const auto& modPath : request.moddata().modpaths())
        {
            modData.modPaths.push_back(modPath);
        }

        modData.serverMods.reserve(request.moddata().mods_size());
        for (const auto& mod : request.moddata().mods())
        {
            modData.serverMods.push_back(mod);
        }

        modData.explodedMods.reserve(request.moddata().explodedmods_size());
        for (const auto& mod : request.moddata().explodedmods())
        {
            modData.explodedMods.push_back(mod);
        }

        s_program->m_modData = modData;
    }

    std::unique_lock<std::mutex> lock(s_program->m_startupMutex);
    s_program->m_startupInitialized = true;
    s_program->m_startupCondition.notify_one();
}

std::optional<std::tuple<std::string, std::string>> LauncherInterface::GetCustomLevelData(std::string mapId, std::string modeId) const
{
    KYBER_LOG(Info, "[RPC] Asking launcher for custom level data...");

    ClientContext context;

    CustomLevelDataRequest request;
    request.set_map(mapId);
    request.set_mode(modeId);

    CustomLevelDataResponse response;

    Status status = m_stub->GetCustomLevelData(&context, request, &response);
    if (!status.ok())
    {
        KYBER_LOG(Error, "[RPC] RPC error while requesting custom level data (" << status.error_message() << ")");
        return std::nullopt;
    }

    // API/internal/rpc/server_browser.go:297
    // If just one of them is invalid, the other one also is and can be ignored
    if (!response.has_mapname())
    {
        return std::nullopt;
    }

    return std::tuple<std::string, std::string>(response.mapname(), response.modename());
}

void LauncherInterface::OnServerJoined() const
{
    KYBER_LOG(Info, "[RPC] Sending server join event to launcher");

    ClientContext context;

    kyber_common::Empty empty;

    Status status = m_stub->OnServerJoined(&context, empty, &empty);
    if (!status.ok())
    {
        KYBER_LOG(Error, "[RPC] RPC error while sending server join event to launcher");
    }
}

void LauncherInterface::OnServerDisconnect() const
{
    KYBER_LOG(Info, "[RPC] Sending server disconnect event to launcher");

    ClientContext context;

    kyber_common::Empty empty;

    Status status = m_stub->OnServerLeft(&context, empty, &empty);
    if (!status.ok())
    {
        KYBER_LOG(Error, "[RPC] RPC error while sending server disconnect event to launcher");
    }
}
} // namespace Kyber
