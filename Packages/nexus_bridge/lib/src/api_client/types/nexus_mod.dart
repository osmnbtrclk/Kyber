import 'package:json_annotation/json_annotation.dart';

part 'nexus_mod.g.dart';

@JsonSerializable()
class NexusMod {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "summary")
  String summary;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "picture_url")
  String pictureUrl;
  @JsonKey(name: "mod_downloads")
  int modDownloads;
  @JsonKey(name: "mod_unique_downloads")
  int modUniqueDownloads;
  @JsonKey(name: "uid")
  int uid;
  @JsonKey(name: "mod_id")
  int modId;
  @JsonKey(name: "game_id")
  int gameId;
  @JsonKey(name: "allow_rating")
  bool allowRating;
  @JsonKey(name: "domain_name")
  String domainName;
  @JsonKey(name: "category_id")
  int categoryId;
  @JsonKey(name: "version")
  String version;
  @JsonKey(name: "endorsement_count")
  int endorsementCount;
  @JsonKey(name: "created_timestamp")
  int createdTimestamp;
  @JsonKey(name: "created_time")
  DateTime createdTime;
  @JsonKey(name: "updated_timestamp")
  int updatedTimestamp;
  @JsonKey(name: "updated_time")
  DateTime updatedTime;
  @JsonKey(name: "author")
  String author;
  @JsonKey(name: "uploaded_by")
  String uploadedBy;
  @JsonKey(name: "uploaded_users_profile_url")
  String uploadedUsersProfileUrl;
  @JsonKey(name: "contains_adult_content")
  bool containsAdultContent;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "available")
  bool available;
  @JsonKey(name: "user")
  User user;
  @JsonKey(name: "endorsement")
  Endorsement endorsement;

  NexusMod({
    required this.name,
    required this.summary,
    required this.description,
    required this.pictureUrl,
    required this.modDownloads,
    required this.modUniqueDownloads,
    required this.uid,
    required this.modId,
    required this.gameId,
    required this.allowRating,
    required this.domainName,
    required this.categoryId,
    required this.version,
    required this.endorsementCount,
    required this.createdTimestamp,
    required this.createdTime,
    required this.updatedTimestamp,
    required this.updatedTime,
    required this.author,
    required this.uploadedBy,
    required this.uploadedUsersProfileUrl,
    required this.containsAdultContent,
    required this.status,
    required this.available,
    required this.user,
    required this.endorsement,
  });

  factory NexusMod.fromJson(Map<String, dynamic> json) =>
      _$NexusModFromJson(json);

  Map<String, dynamic> toJson() => _$NexusModToJson(this);
}

@JsonSerializable()
class Endorsement {
  @JsonKey(name: "endorse_status")
  String endorseStatus;
  @JsonKey(name: "timestamp")
  dynamic timestamp;
  @JsonKey(name: "version")
  dynamic version;

  Endorsement({
    required this.endorseStatus,
    required this.timestamp,
    required this.version,
  });

  factory Endorsement.fromJson(Map<String, dynamic> json) =>
      _$EndorsementFromJson(json);

  Map<String, dynamic> toJson() => _$EndorsementToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "member_id")
  int memberId;
  @JsonKey(name: "member_group_id")
  int memberGroupId;
  @JsonKey(name: "name")
  String name;

  User({
    required this.memberId,
    required this.memberGroupId,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
