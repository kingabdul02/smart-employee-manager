import 'package:intl/intl.dart';

// Function to format currency
String formatCurrency(int amount) {
  final NumberFormat formatter = NumberFormat.simpleCurrency(
    name: 'NGN',
    decimalDigits: 0, // This removes decimal places
  );
  return formatter.format(amount);
}
