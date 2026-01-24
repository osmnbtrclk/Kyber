#include <ToolLib/Main.h>
#include <ToolLib/Pch.h>

#include <consoleapi2.h>
#include <spdlog/sinks/daily_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>

#include <memory>
#include <vector>

ToolLibProgram::ToolLibProgram(std::string name)
{
    toolLibInit(std::move(name));
}

void initConsole()
{
    AllocConsole();
    FILE* pFile;
    freopen_s(&pFile, "CONIN", "r", stdin);
    freopen_s(&pFile, "CONOUT$", "w", stdout);
    freopen_s(&pFile, "CONOUT$", "w", stderr);
}

void toolLibInit(std::string name)
{
    initConsole();

    SetConsoleTitle(name.c_str());

    std::vector<spdlog::sink_ptr> sinks;
    sinks.push_back(std::make_shared<spdlog::sinks::stdout_color_sink_mt>());
    sinks.push_back(std::make_shared<spdlog::sinks::daily_file_sink_mt>(name + ".log", 23, 59));
    auto combined_logger = std::make_shared<spdlog::logger>(name, begin(sinks), end(sinks));
    
    spdlog::register_logger(combined_logger);
    spdlog::set_default_logger(combined_logger);

    auto level = spdlog::level::level_enum::debug;
    spdlog::set_level(level);
    spdlog::flush_on(level);
}