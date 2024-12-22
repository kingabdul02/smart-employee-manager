import 'package:dio/dio.dart';
import 'package:employee_manager/utils/error_handler.dart';
import 'package:logger/logger.dart';

import '../models/Sale.dart';

class SalesService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.hennapos.smartapps.com.ng/api',
    contentType: 'application/json',
  ));

  final ErrorHandler _errorHandler = ErrorHandler();
  final Logger _logger = Logger();

  Future<List<Sale>> getSalesByDate(String date) async {
    try {
      final response =
          await _dio.get('/employee-sales/by-date', data: {'date': date});

      if (response.data['status'] == 'success') {
        return (response.data['sales'] as List)
            .map((sale) => Sale.fromJson(sale))
            .toList();
      }
      throw Exception('Failed to load sales');
    } catch (e) {
      if (e is DioException) {
        final errorMessage = _errorHandler.handleError(e);
        throw errorMessage;
      } else {
        _logger.e('An unexpected error occurred: $e');
        throw Exception('An unexpected error occurred. Please try again.');
      }
    }
  }

  Future<List<Sale>> getSalesByRange(String from, String to) async {
    try {
      final response = await _dio
          .get('/employee-sales/between-dates', data: {'from': from, 'to': to});

      if (response.data['status'] == 'success') {
        return (response.data['sales'] as List)
            .map((sale) => Sale.fromJson(sale))
            .toList();
      }
      throw Exception('Failed to load sales');
    } catch (e) {
      if (e is DioException) {
        final errorMessage = _errorHandler.handleError(e);
        throw errorMessage;
      } else {
        _logger.e('An unexpected error occurred: $e');
        throw Exception('An unexpected error occurred. Please try again.');
      }
    }
  }
}
