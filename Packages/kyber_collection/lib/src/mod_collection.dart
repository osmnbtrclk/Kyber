import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:hive_ce/hive.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:path/path.dart';
import 'package:slugify/slugify.dart';

part 'mod_collection.g.dart';

int _kCollectionVersion = 1;

class ModCollection {
  static Future<bool> hasFileData(File file) async {
    final inputStream = InputFileStream(file.path);
    final archive = ZipDecoder().decodeStream(inputStream);

    final hasFileData = archive.files.length > 1;
    await inputStream.close();

    return hasFileData;
  }

  static Future<ModCollectionMetaData> readCollection(File file) async {
    final inputStream = InputFileStream(file.path);
    try {
      final archive = ZipDecoder().decodeStream(inputStream);

      final metaData = archive.files.where((x) => x.name == 'METADATA').firstOrNull;
      if (metaData == null) {
        throw Exception('Invalid collection');
      }

      final content = metaData.content;
      final collection = ModCollectionMetaData.fromBytes(
        ByteData.view(content.buffer),
      );

      return collection;
    } finally {
      await inputStream.close();
    }
  }

  static Future<void> extractCollection(File file, [Directory? outDir]) async {
    final inputStream = InputFileStream(file.path);
    final archive = ZipDecoder().decodeStream(inputStream);

    final kyberDir = FileHelper.getCollectionDirectory();
    final collectionsDir = outDir ?? Directory(join(kyberDir.path));
    final rawMetaData = archive.files.where((x) => x.name == 'METADATA').firstOrNull;
    if (rawMetaData == null) {
      throw Exception('Invalid collection');
    }

    final metaData = ModCollectionMetaData.fromBytes(
      ByteData.view((rawMetaData.content).buffer),
    );
    final idDir = '${metaData.localId.substring(0, 16)}-${slugify(metaData.title)}';
    final dir = Directory(join(collectionsDir.path, idDir));
    if (dir.existsSync() && dir.listSync().isNotEmpty) {
      //Logger().info('Collection already exists. Skipping extraction');
      return;
    }

    for (final file in archive.files) {
      if (file.isFile) {
        if (file.name == 'METADATA') {
          continue;
        }

        File(join(outDir != null ? outDir.path : join(collectionsDir.path, idDir), file.name))
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as Uint8List);
      }
    }

    await File(join(collectionsDir.path, basename(file.path))).writeAsBytes(rawMetaData.content as Uint8List);

    await inputStream.close();
  }

  static Future<void> writeCollection(
    File target, {
    required ModCollectionMetaData metaData,
    void Function(int current, int total)? onProgress,
    List<File>? modFiles,
  }) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _writeCollection,
      [
        target.path,
        metaData.toBytes(),
        modFiles?.map((e) => e.path).toList(),
        receivePort.sendPort,
      ],
    );
    receivePort.listen((message) {
      final modIndex = message as int;
      onProgress?.call(modIndex, modFiles!.length - 1);
      if (modIndex == modFiles!.length - 1) {
        receivePort.close();
      }
    });
  }

  static void _writeCollection(List<Object?> args) async {
    final target = File(args[0]! as String);
    final metaData = ModCollectionMetaData.fromBytes(
      ByteData.view((args[1]! as Uint8List).buffer),
    );
    final modFiles = (args[2] as List<String>?)?.map(File.new).toList();
    final sendPort = args[3]! as SendPort;
    final encoder = ZipFileEncoder()..create(target.path);

    final metaOut = metaData.toBytes();
    encoder.addArchiveFile(ArchiveFile('METADATA', metaOut.length, metaOut));

    if (modFiles != null) {
      for (final mod in modFiles) {
        sendPort.send(modFiles.indexOf(mod));
        await encoder.addFile(mod);
      }
    }

    encoder.close();
  }
}

@HiveType(typeId: 30)
class ModCollectionMetaData {
  factory ModCollectionMetaData.noMods() => ModCollectionMetaData(
        localId: 'no-mods',
        title: 'No Mods',
        mods: [],
      );

  factory ModCollectionMetaData.fromBytes(ByteData byteData) {
    final reader = ByteReader(byteData);
    final version = reader.readUint32();

    if (version != _kCollectionVersion) {
      throw Exception('Invalid version');
    }

    final localId = reader.readTerminatedString();
    final title = reader.readSizedString();
    final description = reader.readSizedString();
    final isCosmetic = reader.readUint32() == 1;

    final modCount = reader.readUint32();
    final mods = List.generate(modCount, (index) {
      final name = reader.readTerminatedString();
      final version = reader.readTerminatedString();
      final link = reader.readTerminatedString();
      final filename = reader.readTerminatedString();
      final isCollection = bool.parse(reader.readTerminatedString());
      final mods = reader.readTerminatedString().split(',');

      return CollectionMod(
        name: name,
        version: version,
        link: link,
        filename: filename,
        isCollection: isCollection,
        mods: mods,
      );
    });

    return ModCollectionMetaData(
      localId: localId,
      title: title,
      mods: mods,
      isCosmetic: isCosmetic,
      description: description,
    );
  }

  ModCollectionMetaData({
    required this.localId,
    required this.title,
    this.description,
    required this.mods,
    this.isCosmetic = false,
    this.icon,
  });

  @HiveField(0)
  String localId;

  @HiveField(1)
  String title;

  @HiveField(2, defaultValue: '')
  String? description;

  @HiveField(3)
  List<CollectionMod> mods;

  @HiveField(4, defaultValue: false)
  bool isCosmetic;

  @HiveField(5)
  Uint8List? icon;

  Uint8List toBytes() {
    final writer = ByteWriter()
      ..writeUint32(_kCollectionVersion)
      ..writeTerminatedString(localId)
      ..writeSizedString(title)
      ..writeSizedString(description ?? '')
      ..writeUint32(isCosmetic ? 1 : 0)
      ..writeUint32(mods.length);

    for (final mod in mods) {
      writer
        ..writeTerminatedString(mod.name)
        ..writeTerminatedString(mod.version)
        ..writeTerminatedString(mod.link)
        ..writeTerminatedString(mod.filename != null ? basename(mod.filename!) : '')
        ..writeTerminatedString(mod.isCollection.toString())
        ..writeTerminatedString(mod.mods?.join(',') ?? '');
    }

    return writer.toBytes();
  }

  ModCollectionMetaData copyWith({
    String? localId,
    String? title,
    bool? isCosmetic,
    String? description,
    List<CollectionMod>? mods,
    Uint8List? icon,
  }) {
    return ModCollectionMetaData(
      localId: localId ?? this.localId,
      title: title ?? this.title,
      isCosmetic: isCosmetic ?? this.isCosmetic,
      description: description ?? this.description,
      mods: mods ?? this.mods,
      icon: icon ?? this.icon,
    );
  }

  String getDirName() {
    return '${localId.substring(0, 16)}-${slugify(title)}';
  }
}

@HiveType(typeId: 31)
class CollectionMod {
  factory CollectionMod.fromBytes(ByteData byteData) {
    final reader = ByteReader(byteData);
    final name = reader.readTerminatedString();
    final version = reader.readTerminatedString();
    final link = reader.readTerminatedString();
    final filename = reader.readTerminatedString();
    final isCollection = bool.parse(reader.readTerminatedString());
    final mods = reader.readTerminatedString().split(',');

    return CollectionMod(
      name: name,
      version: version,
      link: link,
      filename: filename,
      mods: mods,
      isCollection: isCollection,
    );
  }

  CollectionMod({
    required this.name,
    required this.version,
    required this.link,
    this.isCollection = false,
    this.mods,
    this.filename,
    this.fileData,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String version;

  @HiveField(2)
  String link;

  @HiveField(3)
  bool isCollection;

  @HiveField(4)
  List<String>? mods;

  @HiveField(5)
  String? filename;
  Uint8List? fileData;

  CollectionMod copyWith({
    String? name,
    String? version,
    String? link,
    bool? isCollection,
    List<String>? mods,
    String? filename,
  }) {
    return CollectionMod(
      name: name ?? this.name,
      version: version ?? this.version,
      link: link ?? this.link,
      isCollection: isCollection ?? this.isCollection,
      mods: mods ?? this.mods,
      filename: filename ?? this.filename,
    );
  }

  Uint8List toBytes(CollectionMod mod) {
    final writer = ByteWriter()
      ..writeTerminatedString(mod.name)
      ..writeTerminatedString(mod.version)
      ..writeTerminatedString(mod.link)
      ..writeTerminatedString(mod.filename ?? '')
      ..writeTerminatedString(isCollection.toString())
      ..writeTerminatedString(mods?.join(',') ?? '');

    return writer.toBytes();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollectionMod && other.name == name && other.version == version && other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ version.hashCode ^ link.hashCode;
}
