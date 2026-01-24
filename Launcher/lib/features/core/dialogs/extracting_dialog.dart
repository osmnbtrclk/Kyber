import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/rust/api/archive.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class ExtractingDialog extends StatefulWidget {
  const ExtractingDialog({
    required this.filePath,
    required this.targetDir,
    super.key,
  });

  final String filePath;
  final String targetDir;

  @override
  State<ExtractingDialog> createState() => _ExtractingDialogState();
}

class _ExtractingDialogState extends State<ExtractingDialog> {
  late StreamSubscription<(int, int)> progressStream;

  int current = 0;
  int total = 0;

  double get progress => total == 0 ? 0 : (current / total);

  @override
  void initState() {
    progressStream =
        extractStream(
          filePath: widget.filePath,
          targetDir: widget.targetDir,
        ).listen((event) {
          if (event.$1 == event.$2 - 1) {
            Navigator.of(context).pop();
            return;
          }

          setState(() {
            current = event.$1;
            total = event.$2 - 1;
          });
        });
    super.initState();
  }

  @override
  void dispose() {
    progressStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 400,
      ),
      title: const Text('Extracting'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Extracting $current / $total'),
              const Spacer(),
              Text('(${(progress * 100).toStringAsFixed(1)}%)'),
            ],
          ),
          const SizedBox(height: 8),
          if (current != total)
            ProgressBar(
              value: progress * 100,
            ),
        ],
      ),
    );
  }
}
