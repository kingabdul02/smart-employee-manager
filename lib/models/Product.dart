class Product {
  final int id;
  final String name;
  final String netPrice;
  final String price;
  final int categoryId;
  final int measuringUnitId;
  final String? medicalName;
  final String? manufacturer;
  final String? productImageUrl;
  final String productCode;
  final String? expiryDate;
  final int qtyInStock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sellingPrice;
  final int profitMargin;
  final int vatMargin;

  Product({
    required this.id,
    required this.name,
    required this.netPrice,
    required this.price,
    required this.categoryId,
    required this.measuringUnitId,
    this.medicalName,
    this.manufacturer,
    this.productImageUrl,
    required this.productCode,
    this.expiryDate,
    required this.qtyInStock,
    required this.createdAt,
    required this.updatedAt,
    required this.sellingPrice,
    required this.profitMargin,
    required this.vatMargin,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      netPrice: json['net_price'],
      price: json['price'],
      categoryId: json['category_id'],
      measuringUnitId: json['measuring_unit_id'],
      medicalName: json['medical_name'],
      manufacturer: json['manufacturer'],
      productImageUrl: json['product_image_url'],
      productCode: json['product_code'],
      expiryDate: json['expiry_date'],
      qtyInStock: json['qty_in_stock'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      sellingPrice: json['selling_price'],
      profitMargin: json['profit_margin'],
      vatMargin: json['vat_margin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'net_price': netPrice,
      'price': price,
      'category_id': categoryId,
      'measuring_unit_id': measuringUnitId,
      'medical_name': medicalName,
      'manufacturer': manufacturer,
      'product_image_url': productImageUrl,
      'product_code': productCode,
      'expiry_date': expiryDate,
      'qty_in_stock': qtyInStock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'selling_price': sellingPrice,
      'profit_margin': profitMargin,
      'vat_margin': vatMargin,
    };
  }
}
