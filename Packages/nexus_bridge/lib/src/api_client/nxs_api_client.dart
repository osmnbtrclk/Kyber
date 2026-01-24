import 'package:dio/dio.dart';
import 'package:nexus_bridge/src/api_client/types/nexus_mod.dart';
import 'package:nexus_bridge/src/api_client/types/nexus_mod_file.dart';
import 'package:nexus_bridge/src/api_client/types/nexus_user.dart';
import 'package:nexus_bridge/src/types/nsx_download_link.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'nxs_api_client.g.dart';

const bfGameId = 'starwarsbattlefront22017';

/// Nexus Mods API client
@RestApi(baseUrl: 'https://api.nexusmods.com/v1/')
abstract class NxsApiClient {
  factory NxsApiClient(Dio dio, {String baseUrl}) = _NxsApiClient;

  /// Retrieve specified mod, from a specified game. Cached for 5 minutes.
  @GET('games/{game}/mods/{modId}.json')
  Future<NexusMod> getMod(@Path('game') String game, @Path('modId') int modId);

  /// Lists all files for a specific mod
  @GET('games/{game}/mods/{modId}/files.json')
  Future<NexusModFile> getModFiles(
    @Path('game') String game,
    @Path('modId') int modId,
  );

  /// Endorse a mod
  @POST('games/{game}/mods/{modId}/endorse.json')
  Future<void> endorseMod(@Path('game') String game, @Path('modId') int modId);

  /// Checks an API key is valid and returns the user's details.
  @GET('games/{game}/mods/{modId}/files/{fileId}/download_link.json')
  Future<List<NsxDownloadLink>> getDownloadLink(
    @Path('game') String game,
    @Path('modId') int modId,
    @Path('fileId') int fileId,
    @Query('key') String? key,
    @Query('expires') int? expires,
  );

  /// Checks an API key is valid and returns the user's details.
  @GET('users/validate.json')
  Future<NexusUser> validateUser();
}
