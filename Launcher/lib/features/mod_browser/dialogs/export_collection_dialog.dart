import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class ExportCollectionDialog extends StatefulWidget {
  const ExportCollectionDialog({required this.collection, super.key});

  final ModCollectionMetaData collection;

  @override
  State<ExportCollectionDialog> createState() => _ExportCollectionDialogState();
}

class _ExportCollectionDialogState extends State<ExportCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('Export Collection'),
      constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // exporting a collection will not export the actual mods but only the metadata so that the file can be shared and imported by other users where the mods then get downloaded when not already present
          Text('Export a collection to share it with other users.\n'),
          Text(
            'WARNING: This will not export the actual mods but only the metadata. The mods will be downloaded when the collection is imported by another user.\n',
          ),
          Text(
            'Not every mod can be shared. Some mods may be missing or not available on the server.',
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () async {
            final file = await getSaveLocation(
              suggestedName:
                  '${widget.collection.title} Collection.kbcollection',
              acceptedTypeGroups: [
                const XTypeGroup(
                  label: 'KYBER Collection',
                  extensions: ['kbcollection'],
                ),
              ],
            );

            if (file == null) {
              return;
            }

            await ModCollection.writeCollection(
              File(file.path),
              metaData: widget.collection,
            );
            Navigator.of(context).pop();
            NotificationService.info(message: 'Collection exported');
          },
          text: 'Export',
        ),
      ],
    );
  }
}
