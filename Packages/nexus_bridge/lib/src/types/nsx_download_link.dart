import 'package:json_annotation/json_annotation.dart';

part 'nsx_download_link.g.dart';

@JsonSerializable()
class NsxDownloadLink {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'short_name')
  String shortName;

  @JsonKey(name: 'URI')
  String uri;

  NsxDownloadLink({
    required this.name,
    required this.shortName,
    required this.uri,
  });

  factory NsxDownloadLink.fromJson(Map<String, dynamic> json) => _$NsxDownloadLinkFromJson(json);
}
