// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <SDK/SDK.h>
#include <SDK/TypeInfo.h>

#include <EASTL/fixed_vector.h>
#include <FastDelegate.h>

#include <string>
#include <sstream>

namespace Kyber
{
typedef fastdelegate::FastDelegate<void(const char*)> ExecuteConsoleCommandCallback_t;
TL_DECLARE_FUNC(0x140233E90, void, Console_enqueueCommand, const char* cmdString, ExecuteConsoleCommandCallback_t callback);

class ConsoleStream
{
private:
    std::string input;
    std::string delimiter;
    std::istringstream stream;

public:
    ConsoleStream(const std::string& inputStr, const std::string& delim)
        : input(inputStr)
        , delimiter(delim)
        , stream(input)
    {}

    template<typename T>
    ConsoleStream& operator>>(T& variable)
    {
        std::string token;
        if (std::getline(stream, token, delimiter[0]))
        {
            std::istringstream(token) >> std::boolalpha >> variable;
        }
        return *this;
    }

    ConsoleStream& operator>>(eastl::string& variable)
    {
        std::string token;
        if (std::getline(stream, token, delimiter[0]))
        {
            variable = token.c_str();
        }
        return *this;
    }
};

class ConsoleContext
{
public:
    char pad_0000[352]; // 0x0000
    char* rawArguments; // 0x0160

    void pushOutput(const std::string& out);

    template<typename T>
    ConsoleContext& operator<<(T&& variable)
    {
        std::ostringstream stream;
        stream << std::forward<T>(variable);
        pushOutput(stream.str());
        return *this;
    }

    ConsoleStream stream()
    {
        return ConsoleStream(rawArguments, " ");
    }
};

typedef void (*StaticConsoleMethodPtr_t)(ConsoleContext&);

struct InstanceMethod
{
    const char* name;
    const char* groupName;
    const char* description;
    fastdelegate::FastDelegate<void(ConsoleContext&)> func;
};

struct ConsoleMethod
{
    StaticConsoleMethodPtr_t fptr;
    const char* name;
    const char* groupName;
    const char* description;
};

void ConsoleRegistry_registerInstanceMethod(fastdelegate::FastDelegate1<ConsoleContext&, void>& method, const char* name, const char* groupName);

void RegisterConsoleCommand(StaticConsoleMethodPtr_t func, const char* name, const char* description = 0);

struct EntityOwnerLink
{
    EntityOwnerLink* prev;
    EntityOwnerLink* next;
};

enum SubRealm
{
};

enum EntityCreatorType
{
    EntityCreatorType_Unknown,
    EntityCreatorType_Level,
    EntityCreatorType_Spawner,
    EntityCreatorType_Owner,
    EntityCreatorType_Ghost,
};

class Console
{
public:
    Console();

    void EnqueueCommand(const char* cmd);
    void UnregisterCommand(const char* name);
};
} // namespace Kyber