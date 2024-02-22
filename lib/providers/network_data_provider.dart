import 'package:dio/dio.dart';

class NetworkDataProvider {
  static final NetworkDataProvider _instance = NetworkDataProvider._();
  late Dio _dio;

  NetworkDataProvider._();
  factory NetworkDataProvider() => _instance;

  Future<void> initialize() async {
    _dio = Dio();
  }

  Future<Response> get(String endpoint, {Options? options}) async {
    return _dio.get(endpoint, options: options);
  }
}
