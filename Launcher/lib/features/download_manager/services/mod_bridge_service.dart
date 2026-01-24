import 'package:grpc/grpc.dart';
import 'package:kyber/gen/Proto/mod_bridge.pbgrpc.dart';

const _kServiceHost = 'mod-service.prod.kyber.gg';
const _kServicePort = 443;

class ModBridgeGRPCService {
  ModBridgeGRPCService(this.host, this.port) {
    _channel = ClientChannel(_kServiceHost);
    searchClient = ModSearchClient(_channel);
  }

  factory ModBridgeGRPCService.fromDefaults() =>
      ModBridgeGRPCService(_kServiceHost, _kServicePort);

  factory ModBridgeGRPCService.fromEnv(String env) => ModBridgeGRPCService(
    'mod-sevice.$env.kyber.gg',
    _kServicePort,
  );

  late ClientChannel _channel;
  late ModSearchClient searchClient;

  final String host;
  final int port;

  void dispose() {
    _channel.shutdown();
  }
}
