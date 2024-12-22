import 'package:employee_manager/models/Sale.dart';
import 'package:employee_manager/services/ApiService.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  SalesPageState createState() => SalesPageState();
}

class SalesPageState extends State<SalesPage> {
  final SalesService _salesService = SalesService();
  List<Sale> _sales = [];
  bool _isLoading = false;
  String _selectedDate = DateTime.now().toString().split(' ')[0];

  Future<void> _fetchSales() async {
    setState(() => _isLoading = true);
    try {
      final sales = await _salesService.getSalesByDate(_selectedDate);
      setState(() {
        _sales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Sales'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date.toString().split(' ')[0];
                });
                _fetchSales();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _sales.length,
              itemBuilder: (context, index) {
                final sale = _sales[index];
                return ListTile(
                  title: Text(sale.user.name),
                  subtitle: Text('Date: ${sale.saleDate}'),
                  trailing: Text(
                    '${sale.totalPercentage}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
