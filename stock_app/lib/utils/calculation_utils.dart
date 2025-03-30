import 'dart:math';

class CalculationUtils {
  static double calculateSip(double monthlyInvestment, double annualReturn, int years) {
    final rate = annualReturn / 100 / 12;
    final periods = years * 12;
    return monthlyInvestment * ((pow(1 + rate, periods) - 1) / rate);
  }

  static double calculateReturn(double principal, double annualReturn, int years) {
    return principal * pow(1 + annualReturn / 100, years);
  }

  static double calculateCagr(double startValue, double endValue, int years) {
    return (pow(endValue / startValue, 1 / years) - 1) * 100;
  }

  static double calculateEmi(double principal, double annualRate, int tenureMonths) {
    final monthlyRate = annualRate / 12 / 100;
    return principal * 
           monthlyRate * 
           pow(1 + monthlyRate, tenureMonths) / 
           (pow(1 + monthlyRate, tenureMonths) - 1);
  }
}