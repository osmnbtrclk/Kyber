import 'dart:io';

class ModCollectionHelper {
  static Future<void> extractCollection(File file, [Directory? outDir]) async {
    //final kyberDir = FileHelper.getCollectionDirectory();
    //final collectionsDir = outDir ?? Directory(join(kyberDir.path));
    //final path = join(outDir != null ? outDir.path : join(collectionsDir.path, idDir), file.name);
    //
    //
    //final inputStream = InputFileStream(file.path);
    //final archive = ZipDecoder().decodeBuffer(inputStream);
    //
    //final kyberDir = FileHelper.getCollectionDirectory();
    //final collectionsDir = outDir ?? Directory(join(kyberDir.path));
    //final rawMetaData = archive.files.where((x) => x.name == 'METADATA').firstOrNull;
    //if (rawMetaData == null) {
    //  throw Exception('Invalid collection');
    //}
    //
    //final metaData = ModCollectionMetaData.fromBytes(
    //  ByteData.view((rawMetaData.content as Uint8List).buffer),
    //);
    //final idDir = '${metaData.localId.substring(0, 16)}-${slugify(metaData.title)}';
    //final dir = Directory(join(collectionsDir.path, idDir));
    //if (dir.existsSync() && dir.listSync().isNotEmpty) {
    //  //Logger().info('Collection already exists. Skipping extraction');
    //  return;
    //}
    //
    //for (final file in archive.files) {
    //  if (file.isFile) {
    //    if (file.name == 'METADATA') {
    //      continue;
    //    }
    //
    //    File(join(outDir != null ? outDir.path : join(collectionsDir.path, idDir), file.name))
    //      ..createSync(recursive: true)
    //      ..writeAsBytesSync(file.content as Uint8List);
    //  }
    //}
    //
    //await File(join(collectionsDir.path, basename(file.path))).writeAsBytes(rawMetaData.content as Uint8List);
    //
    //await inputStream.close();
  }
}
