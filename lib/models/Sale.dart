import 'package:employee_manager/models/Product.dart';
import 'package:employee_manager/models/dynamic_model.dart';

import 'User.dart';

class Sale {
  final int id;
  final int userId;
  final String totalPercentage;
  final String saleDate;
  final User user;
  final DynamicModel product;

  Sale({
    required this.id,
    required this.userId,
    required this.totalPercentage,
    required this.saleDate,
    required this.user,
    required this.product,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      userId: json['user_id'],
      totalPercentage: json['total_percentage'],
      saleDate: json['sale_date'],
      user: User.fromJson(json['user']),
      product: DynamicModel.fromJson(json['product']),
    );
  }
}
