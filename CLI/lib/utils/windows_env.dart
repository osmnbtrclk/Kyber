import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final kernel32 = DynamicLibrary.open('kernel32.dll');

class Env {
  Env._();

  static void set(String name, String value) {
    if (Platform.isWindows) {
      _WindowsEnv.set(name, value);
    } else {
      _LinuxEnv.set(name, value);
    }
  }

  static void delete(String name) {
    if (Platform.isWindows) {
      _WindowsEnv.delete(name);
    } else {
      _LinuxEnv.delete(name);
    }
  }
}

class _WindowsEnv {
  _WindowsEnv._();

  static final int Function(Pointer name, Pointer value) _setEnv =
      kernel32.lookupFunction<Int32 Function(Pointer, Pointer), int Function(Pointer, Pointer)>('SetEnvironmentVariableW');

  static void set(String name, String value) {
    final namePtr = name.toNativeUtf16();
    final valuePtr = value.toNativeUtf16();

    final result = _setEnv(namePtr, valuePtr);

    calloc
      ..free(namePtr)
      ..free(valuePtr);

    if (result == 0) {
      throw Exception('Failed to set environment variable');
    }
  }

  static void delete(String name) {
    final namePtr = name.toNativeUtf16();

    final result = _setEnv(namePtr, nullptr);

    calloc.free(namePtr);

    if (result == 0) {
      throw Exception('Failed to delete environment variable');
    }
  }
}

final libc = DynamicLibrary.open('libc.so.6');

class _LinuxEnv {
  _LinuxEnv._();

  static final int Function(Pointer<Utf8> name, Pointer<Utf8> value, int overwrite) _setEnv =
  libc.lookupFunction<Int32 Function(Pointer<Utf8>, Pointer<Utf8>, Int32), int Function(Pointer<Utf8>, Pointer<Utf8>, int)>('setenv');

  static final int Function(Pointer<Utf8> name) _unsetEnv =
  libc.lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>('unsetenv');

  static void set(String name, String value, {bool overwrite = true}) {
    final namePtr = name.toNativeUtf8();
    final valuePtr = value.toNativeUtf8();

    final result = _setEnv(namePtr, valuePtr, overwrite ? 1 : 0);

    calloc
      ..free(namePtr)
      ..free(valuePtr);

    if (result != 0) {
      throw Exception('Failed to set environment variable');
    }
  }

  static void delete(String name) {
    final namePtr = name.toNativeUtf8();

    final result = _unsetEnv(namePtr);

    calloc.free(namePtr);

    if (result != 0) {
      throw Exception('Failed to delete environment variable');
    }
  }
}

