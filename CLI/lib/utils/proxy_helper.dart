import 'package:kyber/kyber.dart';
import 'package:kyber_cli/gen/api/ping.dart';

class ProxyHelper {
  ProxyHelper._();

  static Future<List<KyberProxy>> getProxies() async {
    final api = KyberGRPCService.fromDefaults();
    final proxies = await api.proxyClient.getList(Empty());
    final result = <KyberProxy>[];
    for (final proxy in proxies.proxies) {
      result.add(KyberProxy(ping: 0, proxyInfo: proxy));
      continue;

      final ping = await getPing(ipAddr: proxy.ip);
      result.add(KyberProxy(ping: ping.toInt(), proxyInfo: proxy));
    }

    return result;
  }

  static Future<KyberProxy> getOptimalProxy() async {
    final proxies = await getProxies();
    return proxies.first;
    proxies.sort((a, b) => a.ping.compareTo(b.ping));
    return proxies.first;
  }
}

class KyberProxy {
  int ping;
  ProxyInfo proxyInfo;

  KyberProxy({
    required this.ping,
    required this.proxyInfo,
  });
}
