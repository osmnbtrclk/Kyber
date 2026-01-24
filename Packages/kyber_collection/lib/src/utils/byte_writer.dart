import 'dart:typed_data';

class ByteWriter {
  final ByteData byteData = ByteData(200 * 1024 * 1024);

  ByteWriter();

  int offset = 0;

  Uint8List toBytes() => byteData.buffer.asUint8List(0, offset);

  void writeUint64(int value) {
    byteData.setUint64(offset, value, Endian.little);
    offset += 8;
  }

  void writeUint32(int value) {
    byteData.setUint32(offset, value, Endian.little);
    offset += 4;
  }

  void writeByteData(ByteData data) {
    byteData.buffer.asUint8List().setAll(offset, data.buffer.asUint8List());
    offset += data.lengthInBytes;
  }

  void writeInt(int value) {
    byteData.setInt32(offset, value, Endian.little);
    offset += 4;
  }

  void writeTerminatedString(String str) {
    List<int> strBytes = str.codeUnits;
    byteData.buffer.asUint8List().setAll(offset, strBytes);
    offset += strBytes.length;
    byteData.setUint8(offset, 0);
    offset += 1;
  }

  void writeSizedString(String str) {
    List<int> strBytes = str.codeUnits;
    byteData.setUint8(offset, strBytes.length);
    offset += 1;
    byteData.buffer.asUint8List().setAll(offset, strBytes);
    offset += strBytes.length;
  }
}
