import 'dart:async';
import 'dart:io';

import 'package:kyber_cli/command_runner.dart';
import 'package:kyber_cli/gen/frb_generated.dart';
import 'package:sentry/sentry.dart';

Future<void> main(List<String> args) async {
  await RustLib.init();
  await runZonedGuarded(() async {
    await Sentry.init(
      (options) {
        options.dsn = 'https://6908d6215588b605347d1d446f0bb5ce@sentry.kyber.gg/5';
      },
    );

    await _flushThenExit(await KyberCliCommandRunner().run(args));
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    print('An error occurred. Please try again later.\n${exception.toString()}\n${stackTrace.toString()}');
    exit(1);
  });
}

Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()]).then<void>((_) => exit(status));
}
