import 'package:json_annotation/json_annotation.dart';

part 'nexus_user.g.dart';

@JsonSerializable()
class NexusUser {
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "key")
  String? key;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "is_premium?")
  bool? nexusUserIsPremium;
  @JsonKey(name: "is_supporter?")
  bool? nexusUserIsSupporter;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "profile_url")
  String? profileUrl;
  @JsonKey(name: "is_supporter")
  bool? isSupporter;
  @JsonKey(name: "is_premium")
  bool? isPremium;

  NexusUser({
    this.userId,
    this.key,
    this.name,
    this.nexusUserIsPremium,
    this.nexusUserIsSupporter,
    this.email,
    this.profileUrl,
    this.isSupporter,
    this.isPremium,
  });

  factory NexusUser.fromJson(Map<String, dynamic> json) => _$NexusUserFromJson(json);

  Map<String, dynamic> toJson() => _$NexusUserToJson(this);
}
