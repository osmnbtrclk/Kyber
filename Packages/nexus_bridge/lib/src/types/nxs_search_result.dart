import 'package:json_annotation/json_annotation.dart';

part 'nxs_search_result.g.dart';

@JsonSerializable()
class NexusModsSearchResult {
  @JsonKey(name: "terms")
  List<String> terms;
  @JsonKey(name: "exclude_authors")
  List<dynamic> excludeAuthors;
  @JsonKey(name: "exclude_tags")
  List<dynamic> excludeTags;
  @JsonKey(name: "include_adult")
  bool includeAdult;
  @JsonKey(name: "took")
  int took;
  @JsonKey(name: "total")
  int total;
  @JsonKey(name: "results")
  List<Result> results;

  NexusModsSearchResult({
    required this.terms,
    required this.excludeAuthors,
    required this.excludeTags,
    required this.includeAdult,
    required this.took,
    required this.total,
    required this.results,
  });

  factory NexusModsSearchResult.fromJson(Map<String, dynamic> json) =>
      _$NexusModsSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$NexusModsSearchResultToJson(this);
}

@JsonSerializable()
class Result {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "downloads")
  int downloads;
  @JsonKey(name: "endorsements")
  int endorsements;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "username")
  String username;
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "game_name")
  GameName gameName;
  @JsonKey(name: "game_id")
  int gameId;
  @JsonKey(name: "mod_id")
  int modId;
  @JsonKey(name: "adult")
  bool adult;

  Result({
    required this.name,
    required this.downloads,
    required this.endorsements,
    required this.url,
    required this.image,
    required this.username,
    required this.userId,
    required this.gameName,
    required this.gameId,
    required this.modId,
    required this.adult,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

enum GameName {
  @JsonValue("starwarsbattlefront22017")
  STARWARSBATTLEFRONT22017
}
