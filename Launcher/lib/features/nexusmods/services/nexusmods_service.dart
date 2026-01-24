import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/core/services/storage_helper.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/main.dart';
import 'package:logging/logging.dart';
import 'package:nexus_bridge/nexus_bridge.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:window_to_front/window_to_front.dart';

class NexusModsService {
  NexusBridge? _nexusBridge;
  NexusUser? _nexusUser;

  NexusBridge get nexusBridge => _nexusBridge!;

  NexusUser? get nexusUser => _nexusUser;

  String? get apiToken => Preferences.nexusMods.apiToken;

  final _logger = Logger('nexus_mods_service');

  Future<NexusModsService> getInstance() async {
    if (apiToken != null) {
      final info = await PackageInfo.fromPlatform();
      final osInfo = Platform.operatingSystemVersion;

      _nexusBridge = await NexusBridge.getInstance(
        apiToken: apiToken,
        dio: Dio(
          BaseOptions(
            headers: {
              'User-Agent':
                  'KyberLauncher/v${info.version}-#${info.buildNumber} ($osInfo) Dart/${Platform.version}',
            },
          ),
        )..interceptors.add(DioCacheInterceptor(options: _cacheOptions)),
      );
      await fetchUser();
    } else {
      final info = await PackageInfo.fromPlatform();
      final osInfo = Platform.operatingSystemVersion;

      _nexusBridge = await NexusBridge.getInstance(
        dio: Dio(
          BaseOptions(
            headers: {
              'User-Agent':
              'KyberLauncher/v${info.version}-#${info.buildNumber} ($osInfo) Dart/${Platform.version}',
            },
          ),
        )..interceptors.add(DioCacheInterceptor(options: _cacheOptions)),
      );
    }

    return this;
  }

  Future<void> fetchUser() async {
    try {
      _logger.info('Fetching user data');
      _nexusUser = await (await NexusBridge.getInstance(
        apiToken: apiToken,
      )).apiClient.validateUser();
      _logger
        ..fine('User validated: ${_nexusUser!.name}')
        ..fine('User isPremium: ${_nexusUser!.isPremium}');
    } catch (e, s) {
      NotificationService.error(message: 'Failed to load NexusMods user data');
      _logger.severe('Failed to load NexusMods user data:', e, s);
    }
  }

  Future<String> generateDownloadLink(Uri nxmLink) async {
    final service = sl.get<NexusModsService>();
    final gameId = nxmLink.host;
    final modId = nxmLink.pathSegments[1];
    final fileId = nxmLink.pathSegments.last;

    final downloadUrl = await service.nexusBridge.apiClient.getDownloadLink(
      gameId,
      int.parse(modId),
      int.parse(fileId),
      nxmLink.queryParameters['key'],
      int.parse(nxmLink.queryParameters['expires']!),
    );

    if (downloadUrl.isEmpty) {
      throw Exception('Download URL is empty');
    }

    return downloadUrl.first.uri;
  }

  Future<void> deleteToken() async {
    await HiveCacheStore(
      applicationDocumentsDirectory,
      hiveBoxName: 'dio_nexus_cache',
    ).clean();
    Preferences.nexusMods.apiToken = null;
    _nexusBridge = null;
  }

  Future<void> requestApiToken({
    required void Function(String url) onUrl,
  }) async {
    _logger.info('Requesting NexusMods API token');
    final wsUrl = Uri.parse('wss://sso.nexusmods.com');
    final channel = WebSocketChannel.connect(wsUrl);

    final completer = Completer<void>();
    try {
      await channel.ready.timeout(const Duration(seconds: 10));
      _logger.info('WebSocket connection ready');

      final data = {
        'id': const Uuid().v4(),
        'protocol': 2,
        'token': Preferences.nexusMods.refreshToken,
      };
      channel.sink.add(jsonEncode(data));

      channel.stream.listen(
        (message) async {
          _logger
            ..info('Received message')
            ..fine(message);
          final decoded = jsonDecode(message as String) as Map<String, dynamic>;
          if (decoded['success'] == true) {
            if (decoded['data']['connection_token'] != null) {
              _logger.info('Received connection token');
              Preferences.nexusMods.refreshToken =
                  (decoded['data']['refresh_token'] as String?);
            } else if (decoded['data']['api_key'] != null) {
              _logger.info('Received API token');
              await setApiToken(decoded['data']['api_key'] as String);

              final checkResp = await _nexusBridge!.apiClient.validateUser();
              _logger.info('User validated: ${checkResp.name}');
              NotificationService.showNotification(
                message: 'Logged in as ${checkResp.name}',
                severity: InfoBarSeverity.success,
              );

              await fetchUser();

              Preferences.nexusMods.isLoggedIn = true;

              completer.complete();
              await WindowToFront.activate();
              await fetchUser();
            }
          } else {
            _logger.severe(
              "Error while requesting API token: ${decoded["error"]}",
            );
            completer.completeError(decoded['error'] as String);
          }
        },
        cancelOnError: true,
        onDone: () {
          _logger.info('WebSocket connection closed');
          if (!completer.isCompleted) {
            completer.completeError('WebSocket connection closed');
          }
        },
        onError: (e, s) {
          _logger.severe('Error while receiving message:', e);
          completer.completeError(e.toString());
        },
      );

      onUrl('https://www.nexusmods.com/sso?id=${data["id"]}&application=kyber');

      await completer.future.timeout(const Duration(minutes: 5));
    } catch (e, s) {
      _logger.severe('Error while requesting API token:', e, s);
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    } finally {
      await channel.sink.close();
    }
  }

  Future<void> setApiToken(String token) async {
    _nexusBridge = await NexusBridge.getInstance(
      apiToken: token,
      dio: Dio()..interceptors.add(DioCacheInterceptor(options: _cacheOptions)),
    );
    Preferences.nexusMods.apiToken = token;
  }
}

final _cacheOptions = CacheOptions(
  store: HiveCacheStore(
    StorageHelper.getCacheDir(),
    hiveBoxName: 'dio_nexus_cache',
  ),
  maxStale: const Duration(hours: 4),
  policy: CachePolicy.forceCache,
);

CacheOptions get cacheOptions => _cacheOptions;
