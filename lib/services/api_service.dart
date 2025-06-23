import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> fetchNumberInfo({
    Object? number,
    required String type,
    bool isRandom = false,
  }) async {
    final uri = isRandom
        ? Uri.parse('http://numbersapi.com/random/$type')
        : Uri.parse('http://numbersapi.com/$number/$type');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Ошибка при получении данных: ${response.statusCode}');
    }
  }
}
