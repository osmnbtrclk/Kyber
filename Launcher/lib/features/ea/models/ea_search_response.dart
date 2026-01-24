import 'package:freezed_annotation/freezed_annotation.dart';

part 'ea_search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  SearchResponse({
    required this.personas,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
  List<PersonaElement> personas;

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class PersonaElement {
  PersonaElement({
    required this.persona,
  });

  factory PersonaElement.fromJson(Map<String, dynamic> json) =>
      _$PersonaElementFromJson(json);
  Persona persona;

  Map<String, dynamic> toJson() => _$PersonaElementToJson(this);
}

@JsonSerializable()
class Persona {
  Persona({
    required this.dateCreated,
    required this.displayName,
    required this.nickName,
    required this.nameSpaceName,
    required this.personaId,
    required this.pidId,
    required this.showPersona,
    required this.status,
  });

  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);
  DateTime dateCreated;
  String displayName;
  String nickName;
  String nameSpaceName;
  String personaId;
  String pidId;
  String showPersona;
  String status;

  Map<String, dynamic> toJson() => _$PersonaToJson(this);
}
