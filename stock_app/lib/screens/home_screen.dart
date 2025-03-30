import 'package:flutter/material.dart';
import 'package:stock_app/services/stock_api_service.dart';
import 'package:stock_app/widgets/custom_card.dart';
import 'package:stock_app/widgets/loading_spinner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StockApiService _stockService = StockApiService();
  late Future<List<Stock>> _stocksFuture;

  @override
  void initState() {
    super.initState();
    _stocksFuture = _stockService.getTopStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Market Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Stock>>(
        future: _stocksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stocks available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final stock = snapshot.data![index];
              return CustomCard(
                title: stock.symbol,
                subtitle: '\$${stock.price.toStringAsFixed(2)}',
                trailing: Text(
                  '${stock.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: stock.changePercent >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  // TODO: Navigate to stock detail
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'SIP Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Stock Analysis',
          ),
        ],
      ),
    );
  }
}