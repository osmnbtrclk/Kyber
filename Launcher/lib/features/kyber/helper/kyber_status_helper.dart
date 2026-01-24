import 'package:dio/dio.dart';
import 'package:kyber_launcher/features/lightswitch/models/status.dart';
import 'package:rhttp/rhttp.dart';

class KyberStatusHelper {
  static Future<LightswitchStatus> checkKyberStatus() async {
    return Rhttp.get('https://lightswitch-service.kyber.gg/api/status').then((
      response
    ) {
      final json = Map<String, dynamic>.from(response.bodyToJson as Map);

      return LightswitchStatus.fromJson(json);
    });
  }
}

class KyberStatus {
  final KyberStatusEnum status;
  final String? message;

  KyberStatus({required this.status, this.message});
}

enum KyberStatusEnum {
  up,
  down,
  warning,
}
