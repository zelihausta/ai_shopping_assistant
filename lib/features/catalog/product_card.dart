// ürün adı + içerik bilgisini gösteren kart
import 'package:flutter/material.dart';
import '../../core/product_repository.dart';

class ProductCard extends StatelessWidget {
  final ProductInfo product;
  final double? confidence; // mock
  const ProductCard({super.key, required this.product, this.confidence});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (confidence != null) Text("Güven: ${(confidence! * 100).toStringAsFixed(0)}%"),
          const SizedBox(height: 8),
          Text(product.content),
        ]),
      ),
    );
  }
}
