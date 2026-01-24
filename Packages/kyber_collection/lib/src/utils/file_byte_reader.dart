import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';


import 'package:freezed_annotation/freezed_annotation.dart';

class FileByteReader {
  final RandomAccessFile file;

  FileByteReader(this.file);

  int offset = 0;

  int readUint64() {
    final value = file.readSync(8);
    offset += 8;

    if (value.lengthInBytes < 8) {
      throw Exception('Failed to read 8 bytes');
    }

    return value.buffer.asByteData().getUint64(0, Endian.little);
  }

  Uint8List readUint8List(int size) {
    final outBuffer = Uint8List(size);
    file.readIntoSync(outBuffer);
    offset += size;
    return outBuffer;
  }

  Digest readSha1() {
    final value = file.readSync(20);
    offset += 20;

    return Digest(value);
  }

  int readByte() {
    final value = file.readSync(1).buffer.asByteData().getUint8(0);
    offset += 1;
    return value;
  }

  int readInt() {
    final value = file.readSync(4).buffer.asByteData().getInt32(0, Endian.little);
    offset += 4;
    return value;
  }

  @protected
  int readLong() {
    final value = file.readSync(8).buffer.asByteData().getInt64(0, Endian.little);
    offset += 8;
    return value;
  }

  int readUint32() {
    final value = file.readSync(4);
    offset += 4;

    if (value.lengthInBytes < 4) {
      throw Exception('Failed to read 4 bytes');
    }

    return value.buffer.asByteData().getUint32(0, Endian.little);
  }



  String readTerminatedString() {
    final bytes = <int>[];
    while (true) {
      final byte = file.readSync(1).buffer.asByteData().getUint8(0);
      offset += 1;

      if (byte == 0) {
        break;
      }

      bytes.add(byte);
    }

    return String.fromCharCodes(bytes);
  }

  String readSizedString() {
    final strSize = file.readSync(1).buffer.asByteData().getUint8(0);
    offset += 1;

    final strBytes = file.readSync(strSize);
    final str = String.fromCharCodes(strBytes);
    offset += strSize;

    return str;
  }
}
