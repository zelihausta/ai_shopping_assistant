class ProductDetection {
  final String label;
  final String name;
  final double price;
  final String ingredients;
  ProductDetection({
    required this.label,
    required this.name,
    required this.price,
    required this.ingredients,
  });

  factory ProductDetection.fromJson(Map<String, dynamic> json) {
    return ProductDetection(
      label: json['label'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      ingredients: json['ingredients'] ?? '',
    );
  }
}
