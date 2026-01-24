import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

final kernel32 = DynamicLibrary.open('kernel32.dll');

class ProcessEnv {
  ProcessEnv._();

  static void set(String name, String value) {
    if (Platform.isWindows) {
      WindowsEnv.set(name, value);
    } else if (Platform.isLinux) {
      LinuxEnv.set(name, value);
    } else if (Platform.isMacOS) {
      MacOSEnv.set(name, value);
    } else {
      throw Exception('Unsupported platform');
    }
  }

  static void delete(String name) {
    if (Platform.isWindows) {
      WindowsEnv.delete(name);
    } else if (Platform.isLinux) {
      LinuxEnv.delete(name);
    } else if (Platform.isMacOS) {
      MacOSEnv.delete(name);
    } else {
      throw Exception('Unsupported platform');
    }
  }
}

class WindowsEnv {
  WindowsEnv._();

  static final int Function(Pointer name, Pointer value) _setEnv = kernel32
      .lookupFunction<
        Int32 Function(Pointer, Pointer),
        int Function(Pointer, Pointer)
      >(
        'SetEnvironmentVariableW',
      );

  static void set(String name, String value) {
    final namePtr = name.toNativeUtf16();
    final valuePtr = value.toNativeUtf16();

    final result = _setEnv(namePtr, valuePtr);

    calloc.free(namePtr);
    calloc.free(valuePtr);

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

class LinuxEnv {
  LinuxEnv._();

  static final int Function(
    Pointer<Utf8> name,
    Pointer<Utf8> value,
    int overwrite,
  )
  _setEnv = libc
      .lookupFunction<
        Int32 Function(Pointer<Utf8>, Pointer<Utf8>, Int32),
        int Function(Pointer<Utf8>, Pointer<Utf8>, int)
      >('setenv');

  static final int Function(Pointer<Utf8> name) _unsetEnv = libc
      .lookupFunction<
        Int32 Function(Pointer<Utf8>),
        int Function(Pointer<Utf8>)
      >('unsetenv');

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

final libSystem = DynamicLibrary.open('libSystem.dylib');

class MacOSEnv {
  MacOSEnv._();

  static final int Function(
    Pointer<Utf8> name,
    Pointer<Utf8> value,
    int overwrite,
  )
  _setEnv = libSystem
      .lookupFunction<
        Int32 Function(Pointer<Utf8>, Pointer<Utf8>, Int32),
        int Function(Pointer<Utf8>, Pointer<Utf8>, int)
      >('setenv');

  static final int Function(Pointer<Utf8> name) _unsetEnv = libSystem
      .lookupFunction<
        Int32 Function(Pointer<Utf8>),
        int Function(Pointer<Utf8>)
      >('unsetenv');

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
