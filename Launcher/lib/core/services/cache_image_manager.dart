import 'package:file/file.dart' as f;
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kyber_launcher/main.dart';
import 'package:path/path.dart' as p;

class KyberImageCacheManager extends CacheManager {
  factory KyberImageCacheManager() => _instance ??= KyberImageCacheManager._();

  KyberImageCacheManager._()
    : super(
        Config(
          'ImageCacheManager',
          stalePeriod: const Duration(days: 15),
          maxNrOfCacheObjects: 300,
          fileSystem: _CustomFileSystem(),
        ),
      );

  static KyberImageCacheManager? _instance;
}

class _CustomFileSystem implements FileSystem {
  _CustomFileSystem() : _fileDir = _createDirectory();

  final Future<f.Directory> _fileDir;

  static Future<f.Directory> _createDirectory() async {
    final path = p.join(applicationDocumentsDirectory, 'ImageCache');

    const fs = LocalFileSystem();
    final directory = fs.directory(path);
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<f.File> createFile(String name) async {
    final directory = await _fileDir;
    if (!await directory.exists()) await _createDirectory();
    return directory.childFile(name);
  }
}
