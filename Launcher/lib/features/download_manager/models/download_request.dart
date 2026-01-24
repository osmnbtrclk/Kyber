import 'package:kyber_launcher/features/download_manager/models/download_link_type.dart';

class DownloadRequest {
  const DownloadRequest({
    required this.link,
    required this.displayName,
    this.linkType = DownloadLinkType.nexus,
    this.size,
    this.filename,
    this.metadata,
    this.priority = 5,
    this.group,
  });

  final String link;
  final String displayName;
  final DownloadLinkType linkType;
  final int? size;
  final String? filename;
  final Map<String, dynamic>? metadata;
  final int priority;
  final String? group;
}
