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
  final _monthlyController = TextEditingController();
  final _yearsController = TextEditingController();
  final _returnController = TextEditingController();
  double _result = 0;
  bool _isCalculating = false;

  Future<void> _calculateSIP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCalculating = true);

    try {
      final monthly = double.parse(_monthlyController.text);
      final years = int.parse(_yearsController.text);
      final annualReturn = double.parse(_returnController.text);

      await Future.delayed(const Duration(milliseconds: 500)); // Simulate calculation

      setState(() {
        _result = CalculationUtils.calculateSip(monthly, annualReturn, years);
      });
    } catch (e) {
      ErrorAlert.show(
        context: context,
        title: 'Calculation Error',
        message: 'Invalid input values',
      );
    } finally {
      setState(() => _isCalculating = false);
    }
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _yearsController.dispose();
    _returnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _monthlyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Investment (\$)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Investment Period (Years)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter years';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Enter whole number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _returnController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Expected Annual Return (%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter return rate';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter valid percentage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isCalculating ? null : _calculateSIP,
                  child: _isCalculating
                      ? const CircularProgressIndicator()
                      : const Text('Calculate'),
                ),
                const SizedBox(height: 24),
                if (_result > 0) ...[
                  const Text(
                    'Estimated Returns',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '\$${_result.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on ${_yearsController.text} years at '
                    '${_returnController.text}% annual return',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}