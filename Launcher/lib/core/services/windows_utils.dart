import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

typedef _RtlGetVersionC = Int32 Function(Pointer<OSVERSIONINFO>);
typedef _RtlGetVersionDart = int Function(Pointer<OSVERSIONINFO>);

class WindowsUtils {
  WindowsUtils._();

  static bool isWindowsCompMode() {
    if (!Platform.isWindows) {
      return false;
    }

    final ntdll = DynamicLibrary.open('ntdll.dll');
    final RtlGetVersion = ntdll
        .lookupFunction<_RtlGetVersionC, _RtlGetVersionDart>('RtlGetVersion');
    final osVersionInfo = calloc<OSVERSIONINFO>();

    try {
      osVersionInfo.ref.dwOSVersionInfoSize = sizeOf<OSVERSIONINFO>();
      final result = RtlGetVersion(osVersionInfo);

      if (result == 0) {
        final major = osVersionInfo.ref.dwMajorVersion;
        final minor = osVersionInfo.ref.dwMinorVersion;

        if (major == 6 && minor == 1) {
          return true;
        }
      }

      return false;
    } finally {
      calloc.free(osVersionInfo);
      ntdll.close();
    }
  }

  static bool _isDllPresent(String dllName) {
    final ptr = dllName.toNativeUtf16();
    final hModule = LoadLibraryEx(ptr, 0, LOAD_LIBRARY_SEARCH_SYSTEM32);
    calloc.free(ptr);

    if (hModule != NULL) {
      FreeLibrary(hModule);
      return true;
    }
    return false;
  }

  static bool get isVcRuntimeInstalled {
    return _isDllPresent('vcruntime140.dll') || _isDllPresent('msvcp140.dll');
  }
}
