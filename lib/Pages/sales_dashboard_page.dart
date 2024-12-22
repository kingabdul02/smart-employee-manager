import 'package:employee_manager/models/Sale.dart';
import 'package:employee_manager/services/ApiService.dart';
import 'package:employee_manager/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' show max;

class SalesDashboardPage extends StatefulWidget {
  const SalesDashboardPage({super.key});

  @override
  SalesDashboardPageState createState() => SalesDashboardPageState();
}

class SalesDashboardPageState extends State<SalesDashboardPage> {
  final SalesService _salesService = SalesService();
  List<Sale> _sales = [];
  bool _isLoading = false;
  bool _isRangeMode = false;
  String _selectedDate = DateTime.now().toString().split(' ')[0];
  String _startDate = DateTime.now().toString().split(' ')[0];
  String _endDate = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isRangeMode
              ? '${DateFormat('MMM dd').format(DateTime.parse(_startDate))} - ${DateFormat('MMM dd').format(DateTime.parse(_endDate))}'
              : DateFormat('MMM dd, yyyy')
                  .format(DateTime.parse(_selectedDate)),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildDateSelector(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSales,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    _buildSalesChart(),
                    _buildSalesTable(),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _fetchSales() async {
    setState(() => _isLoading = true);
    try {
      final sales = _isRangeMode
          ? await _salesService.getSalesByRange(_startDate, _endDate)
          : await _salesService.getSalesByDate(_selectedDate);
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

  Widget _buildDateSelector() {
    return Row(children: [
      Switch(
        value: _isRangeMode,
        onChanged: (value) {
          setState(() {
            _isRangeMode = value;
            _fetchSales();
          });
        },
      ),
      Text(_isRangeMode ? 'Date Range' : 'Single Date'),
      _buildDatePicker()
    ]);
  }

  Widget _buildSummaryCards() {
    double totalSales = _sales.fold(
      0,
      (sum, sale) => sum + double.parse(sale.totalPercentage),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildSummaryCard(
            'Total Amount',
            formatCurrency(totalSales.toInt()),
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(width: 16),
          _buildSummaryCard(
            'Employees',
            _sales.map((s) => s.userId).toSet().length.toString(),
            Icons.people,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    if (_sales.isEmpty) return const SizedBox.shrink();

    final Map<String, double> employeeSales = {};
    for (var sale in _sales) {
      employeeSales[sale.user.name] = (employeeSales[sale.user.name] ?? 0) +
          double.parse(sale.totalPercentage);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: employeeSales.values.reduce(max) * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          formatCurrency(value.toInt()),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= employeeSales.length) {
                            return const Text('');
                          }
                          String name =
                              employeeSales.keys.elementAt(value.toInt());
                          return Text(
                            name.length > 12
                                ? '${name.substring(0, 12)}...'
                                : name,
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: employeeSales.entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: employeeSales.keys.toList().indexOf(entry.key),
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.green],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTable() {
    return _sales.isNotEmpty
        ? Card(
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Service')),
                  DataColumn(label: Text('Sales %')),
                ],
                rows: _sales.map((sale) {
                  return DataRow(
                    cells: [
                      DataCell(Text(sale.user.name)),
                      DataCell(Text(DateFormat('MMM dd, yyyy')
                          .format(DateTime.parse(sale.saleDate)))),
                      DataCell(Text(sale.product.get('name'))),
                      DataCell(Text(formatCurrency(
                          double.parse(sale.totalPercentage).toInt()))),
                    ],
                  );
                }).toList(),
              ),
            ),
          )
        : const Center(
            child: Text('No sales record found for the selected date'));
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () async {
          if (_isRangeMode) {
            // Show Date Range Picker
            final pickedRange = await showDateRangePicker(
              context: context,
              initialDateRange: _startDate.isNotEmpty && _endDate.isNotEmpty
                  ? DateTimeRange(
                      start: DateTime.parse(_startDate),
                      end: DateTime.parse(_endDate),
                    )
                  : DateTimeRange(
                      start: DateTime.now(),
                      end: DateTime.now(),
                    ),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedRange != null) {
              setState(() {
                _startDate = pickedRange.start.toString().split(' ')[0];
                _endDate = pickedRange.end.toString().split(' ')[0];
              });
              _fetchSales();
            }
          } else {
            // Show Single Date Picker
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate.isNotEmpty
                  ? DateTime.parse(_selectedDate)
                  : DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate.toString().split(' ')[0];
              });
              _fetchSales();
            }
          }
        },
      ),
    );
  }
}
