import 'package:crypto/crypto.dart';
import 'package:kyber_collection/src/frosty/frosty_mod_reader.dart';
import 'package:kyber_collection/src/utils/file_byte_reader.dart';

class BaseModResource {
  final ModResourceType type;

  BaseModResource(this.type);

  int? resourceIndex = -1;
  String? name;
  Digest? sha1;
  int? size;
  int? flags;
  int? handlerHash;
  String? userData = "";
  List<int> bundlesToAdd = <int>[];

  void read(FileByteReader reader, int readerVersion) {
    resourceIndex = reader.readInt();
    if ((readerVersion <= 3 && resourceIndex != -1) || readerVersion > 3) {
      name = reader.readTerminatedString();
    }

    if (resourceIndex != -1) {
      sha1 = reader.readSha1();
      size = reader.readLong();
      flags = reader.readByte();
      handlerHash = reader.readInt();

      if (readerVersion >= 3) {
        userData = reader.readTerminatedString();
      }
    }

    var count = 0;
    if (readerVersion <= 3 && resourceIndex != -1) {
      count = reader.readInt();
      for (var i = 0; i < count; i++) {
        reader.readInt();
      }

      count = reader.readInt();
      for (var i = 0; i < count; i++) {
        bundlesToAdd.add(reader.readUint32());
      }
    } else if (readerVersion > 3) {
      count = reader.readInt();
      for (var i = 0; i < count; i++) {
        bundlesToAdd.add(reader.readUint32());
      }
    }

    if (type == ModResourceType.Res) {
      reader.readUint32();
      reader.readUint64();

      reader.readUint8List(reader.readInt());
    } else if (type == ModResourceType.Bundle) {
      reader.readTerminatedString();
      reader.readInt();
    } else if (type == ModResourceType.Chunk) {
      reader.readUint32();
      reader.readUint32();
      reader.readUint32();
      reader.readUint32();
      reader.readInt();
      reader.readInt();
    }
  }
}
