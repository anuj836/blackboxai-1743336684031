import 'package:flutter/material.dart';
import 'package:stock_app/services/ai_service.dart';
import 'package:stock_app/widgets/loading_spinner.dart';
import 'package:stock_app/widgets/error_alert.dart';

class StockSuggestorScreen extends StatefulWidget {
  const StockSuggestorScreen({super.key});

  @override
  State<StockSuggestorScreen> createState() => _StockSuggestorScreenState();
}

class _StockSuggestorScreenState extends State<StockSuggestorScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _predictionResult = '';
  String _selectedStock = '';

  Future<void> _getStockPrediction() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _selectedStock = _searchController.text.toUpperCase();
      _predictionResult = '';
    });

    try {
      final prediction = await AiService.predictStockTrend(_selectedStock);
      setState(() {
        _predictionResult = prediction;
      });
    } catch (e) {
      ErrorAlert.show(
        context: context,
        title: 'Prediction Error',
        message: 'Failed to get prediction: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Suggestor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Stock Suggestor',
                applicationVersion: '1.0.0',
                children: [
                  const Text('Get AI-powered stock recommendations'),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter stock symbol (e.g. AAPL)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getStockPrediction,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _getStockPrediction(),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const LoadingSpinner(),
            if (_predictionResult.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Analysis for $_selectedStock',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _predictionResult,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}