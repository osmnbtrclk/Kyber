import 'package:json_annotation/json_annotation.dart';

part 'nexus_mod_file.g.dart';

@JsonSerializable()
class NexusModFile {
  @JsonKey(name: "files")
  List<FileElement> files;
  @JsonKey(name: "file_updates")
  List<FileUpdate> fileUpdates;

  NexusModFile({
    required this.files,
    required this.fileUpdates,
  });

  List<FileElement> filter(CategoryName categoryName) {
    return files.where((x) => x.categoryName == categoryName).toList();
  }

  factory NexusModFile.fromJson(Map<String, dynamic> json) =>
      _$NexusModFileFromJson(json);

  Map<String, dynamic> toJson() => _$NexusModFileToJson(this);
}

@JsonSerializable()
class FileUpdate {
  @JsonKey(name: "old_file_id")
  int oldFileId;
  @JsonKey(name: "new_file_id")
  int newFileId;
  @JsonKey(name: "old_file_name")
  String oldFileName;
  @JsonKey(name: "new_file_name")
  String newFileName;
  @JsonKey(name: "uploaded_timestamp")
  int uploadedTimestamp;
  @JsonKey(name: "uploaded_time")
  DateTime uploadedTime;

  FileUpdate({
    required this.oldFileId,
    required this.newFileId,
    required this.oldFileName,
    required this.newFileName,
    required this.uploadedTimestamp,
    required this.uploadedTime,
  });

  factory FileUpdate.fromJson(Map<String, dynamic> json) =>
      _$FileUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$FileUpdateToJson(this);
}

@JsonSerializable()
class FileElement {
  @JsonKey(name: "id")
  List<int> id;
  @JsonKey(name: "uid")
  int uid;
  @JsonKey(name: "file_id")
  int fileId;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "version")
  String version;
  @JsonKey(name: "category_id")
  int categoryId;
  @JsonKey(name: "category_name", unknownEnumValue: CategoryName.MAIN)
  CategoryName? categoryName;
  @JsonKey(name: "is_primary")
  bool isPrimary;
  @JsonKey(name: "size")
  int size;
  @JsonKey(name: "file_name")
  String fileName;
  @JsonKey(name: "uploaded_timestamp")
  int uploadedTimestamp;
  @JsonKey(name: "uploaded_time")
  DateTime uploadedTime;
  @JsonKey(name: "mod_version")
  String modVersion;
  @JsonKey(name: "external_virus_scan_url")
  String? externalVirusScanUrl;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "size_kb")
  int sizeKb;
  @JsonKey(name: "size_in_bytes")
  int? sizeInBytes;
  @JsonKey(name: "changelog_html")
  String? changelogHtml;
  @JsonKey(name: "content_preview_link")
  String contentPreviewLink;

  FileElement({
    required this.id,
    required this.uid,
    required this.fileId,
    required this.name,
    required this.version,
    required this.categoryId,
    required this.isPrimary,
    required this.size,
    required this.fileName,
    required this.uploadedTimestamp,
    required this.uploadedTime,
    required this.modVersion,
    required this.externalVirusScanUrl,
    required this.description,
    required this.sizeKb,
    required this.sizeInBytes,
    required this.changelogHtml,
    required this.contentPreviewLink,
    this.categoryName,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) =>
      _$FileElementFromJson(json);

  Map<String, dynamic> toJson() => _$FileElementToJson(this);
}

enum CategoryName {
  @JsonValue("ARCHIVED")
  ARCHIVED,
  @JsonValue("MAIN")
  MAIN,
  @JsonValue("OLD_VERSION")
  OLD_VERSION,
  @JsonValue("OPTIONAL")
  OPTIONAL,
}
