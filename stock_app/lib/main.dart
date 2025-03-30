import 'package:flutter/material.dart';
import 'package:stock_app/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/services/stock_api_service.dart';

void main() {
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => StockApiService()),
      ],
      child: MaterialApp(
        title: 'Stock Market App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Inter',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}