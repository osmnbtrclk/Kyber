import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html;

class ModFinderService {
  Future<(String, List<ModVersion>)> searchMod(
    String url,
    String version,
  ) async {
    if (url.isEmpty) {
      throw Exception('URL is empty');
    }

    final modPage = await Dio().get('$url?tab=files');
    if (modPage.statusCode != 200 || url.isEmpty) {
      throw Exception('Could not find mod');
    }

    if (version.contains('(')) {
      version = version.substring(1, version.length - 1);
    }

    final doc = html.parse(modPage.data);
    final versions = doc
        .getElementsByClassName('file-expander-header')
        .where(
          (e) =>
              int.parse(
                e.attributes['data-version']!.replaceAll(RegExp('[^0-9]'), ''),
              ) ==
              int.parse(version.replaceAll(RegExp('[^0-9]'), '')),
        )
        .map(
          (e) => ModVersion(
            name: e.attributes['data-name']!,
            fileId: e.attributes['data-id']!,
            version: e.attributes['data-version']!,
          ),
        );

    if (versions.isEmpty) {
      throw Exception('Could not find version $version');
    }

    final modId = url.split('/').last;
    return (modId, versions.toList());
  }
}

class ModVersion {
  ModVersion({
    required this.name,
    required this.fileId,
    required this.version,
  });

  final String name;
  final String version;
  final String fileId;

  @override
  String toString() => '$name $version';
}
