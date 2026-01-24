import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/services/windows_env.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';

class DebugServerLauncher extends StatefulWidget {
  const DebugServerLauncher({super.key});

  @override
  State<DebugServerLauncher> createState() => _DebugServerLauncherState();
}

class _DebugServerLauncherState extends State<DebugServerLauncher> {
  ClientGRPCService? clientService;
  bool dedicatedServer = false;
  String serverIp = '';
  String kyberApiToken = '';

  @override
  void initState() {
    super.initState();
  }

  Future<int> findAvailablePort() async {
    final server = await ServerSocket.bind('0.0.0.0', 0);
    final port = server.port;
    server.close();
    return port;
  }

  Future<void> startGame() async {
    //var x = await MaximaGameService.startGame(
    //  sl.get<Maxima>(),
    //  useKyber: true,
    //  dedicatedServer: dedicatedServer,
    //);
    //if (!x.dedicatedServer) {
    //  clientService = x.clientService;
    //}
  }

  @override
  Widget build(BuildContext context) {
    return KyberContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debug Server Launcher',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: 8),
          Checkbox(
            content: const Text('Dedicated Server'),
            checked: dedicatedServer,
            onChanged: (value) {
              if (value!) {
                ProcessEnv.set('KYBER_DEDICATED_SERVER', '1');
              } else {
                ProcessEnv.delete('KYBER_DEDICATED_SERVER');
              }
              setState(() => dedicatedServer = value);
            },
          ),
          if (!dedicatedServer) ...[
            const SizedBox(height: 8),
            Text(
              'Server IP',
              style: FluentTheme.of(context).typography.subtitle,
            ),
            const SizedBox(height: 8),
            TextBox(
              placeholder: 'Server IP',
              onChanged: (value) => setState(() => serverIp = value),
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              FilledButton(
                onPressed: startGame,
                child: const Text('Start Game'),
              ),
              const SizedBox(width: 8),
              if (!dedicatedServer)
                FilledButton(
                  child: const Text('Join By Ip'),
                  onPressed: () {},
                  //onPressed: () => clientService?.clientStateClient.joinServerByIP(JoinServerByIPRequest(ip: serverIp)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
