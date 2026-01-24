import 'package:freezed_annotation/freezed_annotation.dart';

part 'patreon_identity_response.g.dart';

@JsonSerializable()
class PatreonResponse {
  PatreonResponse({
    this.data,
    this.included,
    this.links,
  });

  factory PatreonResponse.fromJson(Map<String, dynamic> json) =>
      _$PatreonResponseFromJson(json);
  @JsonKey(name: 'data')
  Data? data;
  @JsonKey(name: 'included')
  List<Included>? included;
  @JsonKey(name: 'links')
  Links? links;

  Map<String, dynamic> toJson() => _$PatreonResponseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.attributes,
    this.id,
    this.relationships,
    this.type,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: 'attributes')
  DataAttributes? attributes;
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'relationships')
  Relationships? relationships;
  @JsonKey(name: 'type')
  String? type;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class DataAttributes {
  DataAttributes({
    this.about,
    this.created,
    this.firstName,
    this.fullName,
    this.imageUrl,
    this.lastName,
    this.thumbUrl,
    this.url,
    this.vanity,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) =>
      _$DataAttributesFromJson(json);
  @JsonKey(name: 'about')
  dynamic about;
  @JsonKey(name: 'created')
  DateTime? created;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'full_name')
  String? fullName;
  @JsonKey(name: 'image_url')
  String? imageUrl;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'thumb_url')
  String? thumbUrl;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'vanity')
  dynamic vanity;

  Map<String, dynamic> toJson() => _$DataAttributesToJson(this);
}

@JsonSerializable()
class Relationships {
  Relationships({
    this.memberships,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) =>
      _$RelationshipsFromJson(json);
  @JsonKey(name: 'memberships')
  Memberships? memberships;

  Map<String, dynamic> toJson() => _$RelationshipsToJson(this);
}

@JsonSerializable()
class Memberships {
  Memberships({
    this.data,
  });

  factory Memberships.fromJson(Map<String, dynamic> json) =>
      _$MembershipsFromJson(json);
  @JsonKey(name: 'data')
  List<Datum>? data;

  Map<String, dynamic> toJson() => _$MembershipsToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'type')
  String? type;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Included {
  Included({
    this.attributes,
    this.id,
    this.type,
  });

  factory Included.fromJson(Map<String, dynamic> json) =>
      _$IncludedFromJson(json);
  @JsonKey(name: 'attributes')
  IncludedAttributes? attributes;
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'type')
  String? type;

  Map<String, dynamic> toJson() => _$IncludedToJson(this);
}

@JsonSerializable()
class IncludedAttributes {
  IncludedAttributes({
    this.campaignLifetimeSupportCents,
    this.currentlyEntitledAmountCents,
    this.fullName,
    this.isFollower,
    this.lastChargeDate,
    this.lastChargeStatus,
    this.lifetimeSupportCents,
    this.nextChargeDate,
    this.note,
    this.patronStatus,
    this.pledgeCadence,
    this.pledgeRelationshipStart,
    this.willPayAmountCents,
  });

  factory IncludedAttributes.fromJson(Map<String, dynamic> json) =>
      _$IncludedAttributesFromJson(json);
  @JsonKey(name: 'campaign_lifetime_support_cents')
  int? campaignLifetimeSupportCents;
  @JsonKey(name: 'currently_entitled_amount_cents')
  int? currentlyEntitledAmountCents;
  @JsonKey(name: 'full_name')
  String? fullName;
  @JsonKey(name: 'is_follower')
  bool? isFollower;
  @JsonKey(name: 'last_charge_date')
  DateTime? lastChargeDate;
  @JsonKey(name: 'last_charge_status')
  String? lastChargeStatus;
  @JsonKey(name: 'lifetime_support_cents')
  int? lifetimeSupportCents;
  @JsonKey(name: 'next_charge_date')
  DateTime? nextChargeDate;
  @JsonKey(name: 'note')
  String? note;
  @JsonKey(name: 'patron_status')
  String? patronStatus;
  @JsonKey(name: 'pledge_cadence')
  int? pledgeCadence;
  @JsonKey(name: 'pledge_relationship_start')
  DateTime? pledgeRelationshipStart;
  @JsonKey(name: 'will_pay_amount_cents')
  int? willPayAmountCents;

  Map<String, dynamic> toJson() => _$IncludedAttributesToJson(this);
}

@JsonSerializable()
class Links {
  Links({
    this.self,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
  @JsonKey(name: 'self')
  String? self;

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
