#pragma once

#include <Windows.h>

#include <string>
#include <thread>

class ToolLibProgram
{
public:
    ToolLibProgram(std::string name);

    virtual ~ToolLibProgram() = default;
    virtual void init() = 0;
};

#define TL_DECLARE_MAIN(type)                                                 \
    BOOL APIENTRY DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved) \
    {                                                                         \
        if (dwReason == DLL_PROCESS_ATTACH)                                   \
        {                                                                     \
            type* inst = new type();                                          \
            new std::thread(&type::init, inst);                               \
        }                                                                     \
        return TRUE;                                                          \
    }

void toolLibInit(std::string name);
