import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_detection.dart';

class DetectionService {
  static const String _baseUrl = 'http://172.20.10.5:8000';


  static Future<List<ProductDetection>> detectProducts(String imagePath) async {
    final url = Uri.parse('$_baseUrl/detect');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Sunucu hatası: ${response.statusCode}');
    }

    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody) as Map<String, dynamic>;

    final List productsJson = data['products'] ?? [];

    return productsJson
        .map((e) => ProductDetection.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
