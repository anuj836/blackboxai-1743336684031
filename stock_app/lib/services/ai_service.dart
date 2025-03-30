class AiService {
  static Future<String> predictStockTrend(String symbol) async {
    // Mock prediction logic
    await Future.delayed(Duration(seconds: 2));
    return 'Predicted trend for $symbol: Bullish';
  }
}