import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:kyber_collection/kyber_collection.dart';

class BSMPlugin {
  static String get path =>
      '${FileHelper.getLauncherDirectory().path}\\Plugins\\BetterSabersPlugin.dll';

  Future<String> generateFile(
    String modsDir,
    List<String> mods,
    String packName,
  ) async {
    return compute(
      (message) {
        final lib = DynamicLibrary.open(
          '${FileHelper.getLauncherDirectory().path}\\Plugins\\BetterSabersPlugin.dll',
        );
        final run = lib
            .lookupFunction<
              Pointer<Utf8> Function(
                Pointer<Utf8>,
                Pointer<Utf8>,
                Pointer<Utf8>,
              ),
              Pointer<Utf8> Function(
                Pointer<Utf8>,
                Pointer<Utf8>,
                Pointer<Utf8>,
              )
            >('Run');

        final modsDirPointer = (message[0] as String).toNativeUtf8();
        final modsPointer = (message[1] as List<String>)
            .join('|')
            .toNativeUtf8();
        final packNamePointer = (message[2] as String).toNativeUtf8();
        final resultPointer = run(modsDirPointer, modsPointer, packNamePointer);
        final result = resultPointer.toDartString();
        calloc
          ..free(modsDirPointer)
          ..free(packNamePointer)
          ..free(modsPointer);

        lib.close();

        return result;
      },
      [modsDir, mods, packName],
    );
  }
}
