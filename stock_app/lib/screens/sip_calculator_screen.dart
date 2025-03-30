import 'package:flutter/material.dart';
import 'package:stock_app/utils/calculation_utils.dart';
import 'package:stock_app/widgets/error_alert.dart';

class SIPCalculatorScreen extends StatefulWidget {
  const SIPCalculatorScreen({super.key});

  @override
  State<SIPCalculatorScreen> createState() => _SIPCalculatorScreenState();
}

class _SIPCalculatorScreenState extends State<SIPCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  final _rateController = TextEditingController();

  double _futureValue = 0;
  double _totalInvestment = 0;
  double _totalReturns = 0;
  bool _isCalculated = false;

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _calculateSIP() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final duration = int.parse(_durationController.text);
      final rate = double.parse(_rateController.text);

      setState(() {
        _futureValue = calculateSIPFutureValue(
          monthlyInvestment: amount,
          durationInYears: duration,
          annualReturnRate: rate,
        );
        _totalInvestment = amount * duration * 12;
        _totalReturns = _futureValue - _totalInvestment;
        _isCalculated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Investment (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter investment amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (Years)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rateController,
                decoration: const InputDecoration(
                  labelText: 'Expected Annual Return Rate (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expected return rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateSIP,
                child: const Text('Calculate'),
              ),
              if (_isCalculated) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildResultCard('Future Value', '\$${_futureValue.toStringAsFixed(2)}'),
                _buildResultCard('Total Investment', '\$${_totalInvestment.toStringAsFixed(2)}'),
                _buildResultCard(
                  'Estimated Returns',
                  '\$${_totalReturns.toStringAsFixed(2)}',
                  color: _totalReturns >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, {Color? color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}