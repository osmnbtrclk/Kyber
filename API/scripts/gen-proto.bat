@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
if "%SCRIPT_DIR:~-1%"=="/" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

for %%I in ("%SCRIPT_DIR%\..") do set "ROOT=%%~fI"
cd /d "%ROOT%"

set "PROTO_DIR=%ROOT%\..\Module\Proto"
set "OUT_BASE=%ROOT%\api\v1"

if exist "%OUT_BASE%\pbcommon" rd /s /q "%OUT_BASE%\pbcommon"
mkdir "%OUT_BASE%\pbcommon"

if exist "%OUT_BASE%\pbapi" rd /s /q "%OUT_BASE%\pbapi"
mkdir "%OUT_BASE%\pbapi"

if exist "%OUT_BASE%\pbea" rd /s /q "%OUT_BASE%\pbea"
mkdir "%OUT_BASE%\pbea"


if exist "%OUT_BASE%\pbmod" rd /s /q "%OUT_BASE%\pbmod"
mkdir "%OUT_BASE%\pbmod"

protoc ^
  -I "%PROTO_DIR%" ^
  -I "%ROOT%\..\Module" ^
  --go_out=paths=source_relative:"%OUT_BASE%\pbcommon" ^
  --go-grpc_out=paths=source_relative:"%OUT_BASE%\pbcommon" ^
  "%PROTO_DIR%\kyber_common.proto"

protoc ^
  -I "%PROTO_DIR%" ^
  -I "%ROOT%\..\Module" ^
  --go_out=paths=source_relative:"%OUT_BASE%\pbapi" ^
  --go-grpc_out=paths=source_relative:"%OUT_BASE%\pbapi" ^
  "%PROTO_DIR%\kyber_api.proto"

protoc ^
  -I "%PROTO_DIR%" ^
  -I "%ROOT%\..\Module" ^
  --go_out=paths=source_relative:"%OUT_BASE%\pbea" ^
  --go-grpc_out=paths=source_relative:"%OUT_BASE%\pbea" ^
  "%PROTO_DIR%\kyber_ea_bridge.proto"

protoc ^
  -I "%PROTO_DIR%" ^
  -I "%ROOT%\..\Module" ^
  --go_out=paths=source_relative:"%OUT_BASE%\pbmod" ^
  --go-grpc_out=paths=source_relative:"%OUT_BASE%\pbmod" ^
  "%PROTO_DIR%\mod_bridge.proto"

