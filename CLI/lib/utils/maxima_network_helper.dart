import 'package:dio/dio.dart';

const String _maximaConnectionString = 'http://127.0.0.1:13021';

class MaximaNetworkHelper {
  static Future<Response<T>> maximaRequest<T>(
    String path, {
    dynamic data,
    String? method,
  }) =>
      Dio().request<T>(
        '$_maximaConnectionString/$path',
        data: data,
        options: Options(method: method),
      );
}
