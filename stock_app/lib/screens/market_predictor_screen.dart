import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stock_app/services/ai_service.dart';
import 'package:stock_app/widgets/loading_spinner.dart';

class MarketPredictorScreen extends StatefulWidget {
  const MarketPredictorScreen({super.key});

  @override
  State<MarketPredictorScreen> createState() => _MarketPredictorScreenState();
}

class _MarketPredictorScreenState extends State<MarketPredictorScreen> {
  final AIService _aiService = AIService();
  late Future<MarketPrediction> _predictionFuture;
  String _currentIndex = 'S&P 500';

  @override
  void initState() {
    super.initState();
    _predictionFuture = _aiService.getMarketPrediction(_currentIndex);
  }

  void _refreshPrediction(String index) {
    setState(() {
      _currentIndex = index;
      _predictionFuture = _aiService.getMarketPrediction(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Predictor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshPrediction(_currentIndex),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _currentIndex,
              items: const [
                DropdownMenuItem(
                  value: 'S&P 500',
                  child: Text('S&P 500'),
                ),
                DropdownMenuItem(
                  value: 'NASDAQ',
                  child: Text('NASDAQ'),
                ),
                DropdownMenuItem(
                  value: 'DOW',
                  child: Text('DOW'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _refreshPrediction(value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Market Index',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<MarketPrediction>(
              future: _predictionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingSpinner();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No prediction available'),
                  );
                }

                final prediction = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: charts.TimeSeriesChart(
                          [
                            charts.Series<TimeSeriesValue, DateTime>(
                              id: 'Historical',
                              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                              domainFn: (value, _) => value.time,
                              measureFn: (value, _) => value.value,
                              data: prediction.historicalData,
                            ),
                            charts.Series<TimeSeriesValue, DateTime>(
                              id: 'Predicted',
                              colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
                              domainFn: (value, _) => value.time,
                              measureFn: (value, _) => value.value,
                              data: prediction.predictedData,
                            ),
                          ],
                          animate: true,
                          domainAxis: const charts.DateTimeAxisSpec(),
                          primaryMeasureAxis: const charts.NumericAxisSpec(
                            tickProviderSpec:
                                charts.BasicNumericTickProviderSpec(
                              desiredMinTickCount: 6,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Market Outlook',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  prediction.summary,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      'Confidence: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${prediction.confidence}%',
                                      style: TextStyle(
                                        color: prediction.confidence >= 70
                                            ? Colors.green
                                            : prediction.confidence >= 50
                                                ? Colors.orange
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Trend: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      prediction.trend,
                                      style: TextStyle(
                                        color: prediction.trend == 'Bullish'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSeriesValue {
  final DateTime time;
  final double value;

  TimeSeriesValue(this.time, this.value);
}

class MarketPrediction {
  final List<TimeSeriesValue> historicalData;
  final List<TimeSeriesValue> predictedData;
  final String summary;
  final int confidence;
  final String trend;

  MarketPrediction({
    required this.historicalData,
    required this.predictedData,
    required this.summary,
    required this.confidence,
    required this.trend,
  });
}