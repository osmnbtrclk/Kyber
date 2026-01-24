import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_cli/command_runner.dart';
import 'package:kyber_cli/gen/api/maxima.dart';
import 'package:kyber_cli/utils/windows_env.dart';
import 'package:mason_logger/mason_logger.dart';

class GetTokenCommand extends Command<int> {
  GetTokenCommand({
    required Logger logger,
  }) : _logger = logger;

  @override
  String get description => '''
    Fetches the Kyber auth token.
  ''';

  @override
  String get name => 'get_token';

  final Logger _logger;

  @override
  Future<int> run() async {
    _logger.info('Starting login flow...');
    late ServicePlayer player;
    try {
      player = await loginFlow();
    } catch (e) {
      if (e is PanicException || e is AnyhowException) {
        final err = e is PanicException ? e.message : (e as AnyhowException).message;
        if (err.contains('unknown variant `NO_SUCH_USER`')) {
          _logger.err('Login failed: The specified user does not exist');
        } else {
          _logger.err('Login failed: $err');
        }
        return ExitCode.usage.code;
      }

      _logger.err('Login failed: $e');
      return ExitCode.usage.code;
    }

    _logger.success('Logged in as ${player.displayName}.');

    final authToken = await getAuthToken();

    final kToken = await sl.get<KyberGRPCService>().getAuthToken(authToken);

    _logger.info('Kyber auth token: $kToken');

    return ExitCode.success.code;
  }
}
