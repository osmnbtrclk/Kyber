import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class DeleteCollectionDialog extends StatefulWidget {
  const DeleteCollectionDialog({required this.collection, super.key});

  final ModCollectionMetaData collection;

  @override
  State<DeleteCollectionDialog> createState() => _DeleteCollectionDialogState();
}

class _DeleteCollectionDialogState extends State<DeleteCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Delete Collection'),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Are you sure you want to delete this collection? This action cannot be undone.',
            style: TextStyle(
              color: kWhiteColor,
            ),
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () {
            collectionBox.delete(widget.collection.localId);
            Navigator.of(context).pop(true);
          },
          text: 'Delete',
        ),
      ],
    );
  }
}
