// Copyright Armchair Developers / Sean Kahler. Licensed under GPLv3.

#pragma once

#include <Windows.h>

namespace Kyber
{
class ErrorUtils
{
public:
    static void ThrowException(LPCSTR message);
    static void CloseGame(LPCSTR message);
};
} // namespace Kyber