import 'dart:async';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class ImageCropDialog extends StatefulWidget {
  const ImageCropDialog({required this.imageData, super.key});

  final Uint8List imageData;

  @override
  State<ImageCropDialog> createState() => _ImageCropDialogState();
}

class _ImageCropDialogState extends State<ImageCropDialog> {
  final _controller = CropController();

  final Completer<Uint8List> _croppedDataCompleter = Completer<Uint8List>();

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Crop Image'),
      constraints: const .new(
        maxWidth: 800,
        maxHeight: 600,
      ),
      content: Crop(
        image: widget.imageData,
        controller: _controller,
        onCropped: (result) {
          if (result is CropFailure) {
            if (!_croppedDataCompleter.isCompleted) {
              _croppedDataCompleter.completeError(result.cause, result.stackTrace);
            }
            return;
          }

          if (!_croppedDataCompleter.isCompleted) {
            _croppedDataCompleter.complete((result as CropSuccess).croppedImage);
          }
        },
      ),
      actions: [
        KyberButton(text: 'CANCEL', onPressed: () => Navigator.of(context).pop()),
        KyberButton(
          text: 'SAVE',
          onPressed: () async {
            _controller.crop();
            final croppedData = await _croppedDataCompleter.future;
            Navigator.of(context).pop(croppedData);
          },
        ),
      ],
    );
  }
}
