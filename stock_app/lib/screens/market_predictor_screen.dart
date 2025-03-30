import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stock_app/services/stock_api_service.dart';
import 'package:stock_app/widgets/loading_spinner.dart';
import 'package:stock_app/widgets/error_alert.dart';

class MarketPredictorScreen extends StatefulWidget {
  const MarketPredictorScreen({super.key});

  @override
  State<MarketPredictorScreen> createState() => _MarketPredictorScreenState();
}

class _MarketPredictorScreenState extends State<MarketPredictorScreen> {
  final StockApiService _apiService = StockApiService();
  bool _isLoading = false;
  List<MarketData> _marketData = [];
  String _selectedTimeframe = '1M';
  String _selectedIndex = 'S&P 500';

  @override
  void initState() {
    super.initState();
    _fetchMarketData();
  }

  Future<void> _fetchMarketData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.getMarketData();
      setState(() {
        _marketData = data.map((e) => MarketData.fromJson(e)).toList();
      });
    } catch (e) {
      ErrorAlert.show(
        context: context,
        title: 'Data Error',
        message: 'Failed to load market data: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMarketData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingSpinner()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: _selectedIndex,
                        items: ['S&P 500', 'NASDAQ', 'DOW', 'RUSSELL 2000']
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedIndex = value!);
                          _fetchMarketData();
                        },
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedTimeframe,
                        items: ['1D', '1W', '1M', '3M', '1Y', '5Y']
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedTimeframe = value!);
                          _fetchMarketData();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Price (\$)'),
                      ),
                      title: ChartTitle(text: '$_selectedIndex Performance'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries>[
                        LineSeries<MarketData, String>(
                          name: 'Closing Price',
                          dataSource: _marketData,
                          xValueMapper: (data, _) => data.date,
                          yValueMapper: (data, _) => data.value,
                          dataLabelSettings: const DataLabelSettings(isVisible: false),
                          markerSettings: const MarkerSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class MarketData {
  final String date;
  final double value;

  MarketData({required this.date, required this.value});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      date: json['date'],
      value: json['value'].toDouble(),
    );
  }
}