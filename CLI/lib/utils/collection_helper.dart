import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kyber_cli/utils/api_service.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:mason_logger/mason_logger.dart';

class CollectionHelper {
  final _logger = Logger();

  Future<List<String>> getCollectionList() async {
    final collectionDir = FileHelper.getCollectionDirectory();
    if (!collectionDir.existsSync()) {
      return [];
    }

    return collectionDir.listSync().map((e) => e.path).toList();
  }

  List<String> getModsList(ModCollectionMetaData metaData, {bool listFrostyCollectionMods = true, String? modDirectory}) {
    final paths = List<String>.empty(growable: true);
    for (final mod in metaData.mods) {
      if (!mod.isCollection) {
        paths.add(mod.filename!);
      } else {
        if (listFrostyCollectionMods) {
          for (final collectionMod in mod.mods!) {
            paths.add(collectionMod);
          }
        } else {
          paths.add(mod.filename!);
        }
      }
    }

    return paths;
  }

  String getModsDirectory() {
    return FileHelper.getCollectionDirectory().path;
  }

  Future<void> useCollection(File collectionFile) async {
    if (!collectionFile.existsSync()) {
      throw Exception('Collection file not found');
    }

    final metaData = await ModCollection.readCollection(collectionFile);
    _logger.info('Loading Mod Collection "${metaData.title}" with ${metaData.mods.length} mods');

    final hasModData = await ModCollection.hasFileData(collectionFile);
    if (!hasModData) {
      //await _downloadMods(metaData);
    } else {
      final started = DateTime.now();
      _logger.info('Extracting Collection');
      await ModCollection.extractCollection(collectionFile);
      _logger.info('Extracting done. (Took ${DateTime.now().millisecondsSinceEpoch - started.millisecondsSinceEpoch}ms)');
    }
  }

  Future<void> _downloadMods(ModCollectionMetaData metaData) async {
    _logger.info('Mod Collection does not contain any mod data... Downloading...');
    for (final mod in metaData.mods) {
      _logger.info('Downloading ${mod.name} (v${mod.version})');

      if (mod.filename == null || mod.filename!.isEmpty) {
        _logger.err('Error: Mod does not have a filename');
        continue;
      }

      final modName = '${mod.name} (${mod.version})';
      var downloadInfo = await ApiService.getDownloadInfo(modName);
      if (downloadInfo == null && mod.link.isEmpty) {
        _logger.err('Error: Could not find any download');
        continue;
      }

      downloadInfo ??= await ApiService().getInfoByLink(mod.link, mod.version);
      if (downloadInfo == null) {
        _logger.err('Error: Could not find any download');
        continue;
      }

      /*final resp = await NxsApiClient(Dio()).getDownloadLink(
        bfGameId,
        2,
        int.parse(downloadInfo.fileId),
        null,
        null,
      );

      _logger.info('Starting Download...');
      await Dio().download(resp.first.uri, '${FileHelper.getCollectionDirectory().path}/${mod.filename!}');*/
    }
  }
}
