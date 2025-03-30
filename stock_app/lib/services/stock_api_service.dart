import 'package:http/http.dart' as http;
import 'dart:convert';

class StockApiService {
  static const String _baseUrl = 'https://api.example.com/stocks';

  Future<Map<String, dynamic>> getStockData(String symbol) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$symbol'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMarketData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/market'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load market data');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}