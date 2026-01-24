import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:kyber_launcher/gen/generated_bindings.dart';
import 'package:path/path.dart';

void extractRar(String rarFilePath, String outputDirectory, {SendPort? sendPort}) {
  const dllPath = 'UnRAR.dll';
  final unrar = NativeLibrary(DynamicLibrary.open(dllPath));

  final totalFiles = _getTotalFiles(unrar, rarFilePath);

  final rarArchiveData = calloc<RAROpenArchiveData>();
  rarArchiveData.ref
    ..ArcName = rarFilePath.toNativeUtf8().cast<Char>()
    ..OpenMode = RAR_OM_EXTRACT;

  final result = rarArchiveData.ref.OpenResult;
  if (result != 0) {
    calloc.free(rarArchiveData);
    throw Exception('Failed to open archive');
  }

  final rarHandle = unrar.RAROpenArchive(rarArchiveData);
  if (rarHandle.address == 0) {
    calloc.free(rarArchiveData);
    throw Exception('Failed to open archive');
  }

  final rarHeader = calloc<RARHeaderData>();

  var currentFileIndex = 0;
  while (unrar.RARReadHeader(rarHandle, rarHeader) == 0) {
    currentFileIndex++;

    sendPort?.send({
      'extracted': currentFileIndex,
      'total': totalFiles,
    });

    final fileName = _convertToString(rarHeader.ref.FileName);

    final result = unrar.RARProcessFile(
      rarHandle,
      RAR_EXTRACT,
      nullptr,
      join(outputDirectory, fileName).toNativeUtf8().cast<Char>(),
    );

    if (result != 0) {
      break;
    }
  }

  unrar.RARCloseArchive(rarHandle);
  calloc
    ..free(rarHeader)
    ..free(rarArchiveData);
}

int _getTotalFiles(NativeLibrary unrar, String filePath) {
  final archiveData = calloc<RAROpenArchiveDataEx>();
  archiveData.ref.ArcName = filePath.toNativeUtf8().cast<Char>();
  archiveData.ref.OpenMode = RAR_OM_EXTRACT;

  final handle = unrar.RAROpenArchiveEx(archiveData);
  if (handle == nullptr) {
    calloc.free(archiveData);
    return 0;
  }

  var fileCount = 0;
  final header = calloc<RARHeaderData>();

  while (unrar.RARReadHeader(handle, header) == 0) {
    fileCount++;
    unrar.RARProcessFile(handle, RAR_SKIP, nullptr, nullptr);
  }

  unrar.RARCloseArchive(handle);
  calloc
    ..free(header)
    ..free(archiveData);

  return fileCount;
}

String _convertToString(Array<Char> array) {
  final sb = StringBuffer();
  for (var i = 0; i < 260; i++) {
    final char = array[i];

    if (char == 0) break;

    sb.writeCharCode(char);
  }

  return sb.toString();
}
