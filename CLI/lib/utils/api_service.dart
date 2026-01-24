import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart';

class ApiService {
  static Future<DownloadInfo?> getDownloadInfo(String modName) async {
    try {
      final resp = await get(Uri.parse('https://mod-bridge.reax.at/v2/mods?q=$modName'));
      if (resp.statusCode == 200) {
        return DownloadInfo.fromJson(json.decode(resp.body) as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<DownloadInfo?> getInfoByLink(String url, String version) async {
    if (!url.contains("nexusmods.com")) {
      return null;
    }

    final result = await searchMod(url, version);
    if (result == null || result.$2.isEmpty) {
      return null;
    }

    if (result.$2.length > 1) {
      return null;
    }

    return DownloadInfo(
      fileId: result.$2.first.fileId,
      fileName: result.$2.first.name,
      fileUrl: "https://www.nexusmods.com/starwarsbattlefront22017/mods/${result.$1}",
    );
  }

  Future<(String, List<ModVersion>)> searchMod(
    String url,
    String version,
  ) async {
    final modPage = await Dio().get("$url?tab=files");
    if (modPage.statusCode != 200) {
      throw Exception("Could not find mod");
    }

    var doc = html.parse(modPage.data);
    var versions = doc.getElementsByClassName("file-expander-header").where((e) => e.attributes['data-version']! == version).map(
          (e) => ModVersion(
            name: e.attributes['data-name'] as String,
            fileId: e.attributes['data-id'] as String,
            version: e.attributes['data-version'] as String,
          ),
        );

    if (versions.isEmpty) {
      throw Exception("Could not find version $version");
    }

    final modId = url.split("/").last;
    return (modId, versions.toList());
  }
}

class ModVersion {
  final String name;
  final String version;
  final String fileId;

  @override
  String toString() => "$name $version";

  ModVersion({
    required this.name,
    required this.fileId,
    required this.version,
  });
}

class DownloadInfo {
  DownloadInfo({
    required this.fileId,
    required this.fileName,
    required this.fileUrl,
    this.link,
  });

  String? link;
  String fileName;
  String fileUrl;
  String fileId;

  factory DownloadInfo.fromJson(Map<String, dynamic> json) => DownloadInfo(
        link: json['link'] as String?,
        fileName: json['fileName'] as String,
        fileUrl: json['fileUrl'] as String,
        fileId: json['fileId'] as String,
      );
}
