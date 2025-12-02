import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();

  ApiClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      error: true,
      logPrint: (object) {
        logger.d(object);
      },
    ));
  }

  // Метод для проверки соединения
  Future<bool> testConnection() async {
    try {
      final response = await dio.get(
        '/posts/1',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}