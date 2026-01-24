import 'package:dio/dio.dart';
import 'package:kyber_launcher/features/ea/models/ea_search_response.dart';
import 'package:logging/logging.dart';

class SearchService {
  SearchService({required String eaToken}) {
    _client = Dio(
      BaseOptions(
        headers: {
          'Authorization': 'Bearer $eaToken',
          'Accept': 'application/json',
          'User-Agent': 'Respawn HTTPS/1.0',
        },
      ),
    );
  }

  late Dio _client;
  final Logger _logger = Logger('search_service');

  Future<List<Persona>> search({required String query}) async {
    try {
      final response = await _client.get<dynamic>(
        'https://gateway.ea.com/proxy/playersearch/api/search',
        queryParameters: {
          'users': true,
          'query': 'displayName~"$query"',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final eaResponse = SearchResponse.fromJson(response.data as Map<String, dynamic>);
        return eaResponse.personas.map((e) => e.persona).toList();
      } else {
        _logger.warning(
          'Failed to search personas: ${response.statusCode} ${response.statusMessage}',
        );
        return [];
      }
    } catch (e, st) {
      _logger.severe('Error searching personas', e, st);
      return [];
    }
  }
}
