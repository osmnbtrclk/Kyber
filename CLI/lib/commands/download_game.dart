import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:kyber_cli/gen/api/maxima.dart';
import 'package:mason_logger/mason_logger.dart';

class SetupServerCommand extends Command<int> {
  SetupServerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'download-path',
        abbr: 'p',
        help: 'Specify the path to download the game to',
      )
      ..addOption(
        'token',
        abbr: 't',
        help: 'Specify the token to use for EA login',
      );
  }

  @override
  String get description => '''Download Star Wars: Battlefront 2''';

  @override
  String get name => 'download_game';

  final Logger _logger;

  @override
  Future<int> run() async {
    if (argResults?['token'] == null) {
      _logger.err('Token is required');
      return ExitCode.usage.code;
    }

    if (argResults?['download-path'] == null) {
      _logger.err('Download path is required');
      return ExitCode.usage.code;
    }

    _logger.info('Using token...');
    await loginWithToken(token: argResults?['token'] as String);

    _logger.info('Starting game download...');
    final isDownloaded = Completer<void>();
    final message = _logger.progress('Downloading game... (0%)');
    try {
      downloadGame(downloadPath: argResults?['download-path'] as String).listen(
        (event) {
          final progress = (event.$1 / event.$2) * 100;
          message.update('Downloading game... (${progress.toStringAsFixed(2)}%)');
        },
        onDone: () {
          isDownloaded.complete();
          _logger.info('Download complete');
        },
      );

      await isDownloaded.future;

      return ExitCode.success.code;
    } catch (e, s) {
      _logger.err('Download failed: $e');
      return ExitCode.software.code;
    }
  }
}
