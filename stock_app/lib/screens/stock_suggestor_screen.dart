import 'package:flutter/material.dart';
import 'package:stock_app/models/stock_model.dart';
import 'package:stock_app/services/ai_service.dart';
import 'package:stock_app/widgets/custom_card.dart';
import 'package:stock_app/widgets/loading_spinner.dart';

class StockSuggestorScreen extends StatefulWidget {
  const StockSuggestorScreen({super.key});

  @override
  State<StockSuggestorScreen> createState() => _StockSuggestorScreenState();
}

class _StockSuggestorScreenState extends State<StockSuggestorScreen> {
  final AIService _aiService = AIService();
  late Future<List<Stock>> _suggestedStocks;
  String _currentStrategy = 'Conservative';

  @override
  void initState() {
    super.initState();
    _suggestedStocks = _aiService.getSuggestedStocks(_currentStrategy);
  }

  void _refreshSuggestions(String strategy) {
    setState(() {
      _currentStrategy = strategy;
      _suggestedStocks = _aiService.getSuggestedStocks(strategy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Stock Suggestor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshSuggestions(_currentStrategy),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _currentStrategy,
              items: const [
                DropdownMenuItem(
                  value: 'Conservative',
                  child: Text('Conservative'),
                ),
                DropdownMenuItem(
                  value: 'Balanced',
                  child: Text('Balanced'),
                ),
                DropdownMenuItem(
                  value: 'Aggressive',
                  child: Text('Aggressive'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _refreshSuggestions(value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Investment Strategy',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Stock>>(
              future: _suggestedStocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingSpinner();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No suggestions available'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final stock = snapshot.data![index];
                    return CustomCard(
                      title: stock.symbol,
                      subtitle: stock.name,
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${stock.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${stock.changePercent.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: stock.changePercent >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Show detailed analysis
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}