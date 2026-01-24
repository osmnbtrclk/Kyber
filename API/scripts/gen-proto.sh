#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

MODULE_ROOT="$(cd "$ROOT/../Module" && pwd)"
PROTO_DIR="$MODULE_ROOT/Proto"
OUT_BASE="$ROOT/api/v1"

for pkg in pbcommon pbapi pbea pbmod; do
  rm -rf "$OUT_BASE/$pkg"
  mkdir -p "$OUT_BASE/$pkg"
done

protoc \
  -I "$PROTO_DIR" \
  -I "$MODULE_ROOT" \
  --go_out=paths=source_relative:"$OUT_BASE/pbcommon" \
  --go-grpc_out=paths=source_relative:"$OUT_BASE/pbcommon" \
  "$PROTO_DIR/kyber_common.proto"

protoc \
  -I "$PROTO_DIR" \
  -I "$MODULE_ROOT" \
  --go_out=paths=source_relative:"$OUT_BASE/pbapi" \
  --go-grpc_out=paths=source_relative:"$OUT_BASE/pbapi" \
  "$PROTO_DIR/kyber_api.proto"

protoc \
  -I "$PROTO_DIR" \
  -I "$MODULE_ROOT" \
  --go_out=paths=source_relative:"$OUT_BASE/pbea" \
  --go-grpc_out=paths=source_relative:"$OUT_BASE/pbea" \
  "$PROTO_DIR/kyber_ea_bridge.proto"

protoc \
  -I "$PROTO_DIR" \
  -I "$MODULE_ROOT" \
  --go_out=paths=source_relative:"$OUT_BASE/pbmod" \
  --go-grpc_out=paths=source_relative:"$OUT_BASE/pbmod" \
  "$PROTO_DIR/mod_bridge.proto"

