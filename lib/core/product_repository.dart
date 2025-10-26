//assets/product_info.json'u okur
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductInfo {
  //Bu sınıf, bir ürünün bilgilerini temsil eder. Ürünle ilgili dört özellik içerir:
  final String id;
  final String displayName;
  final String content;
  final List<String> tags;
  ProductInfo({required this.id, required this.displayName, required this.content, required this.tags});
}

class ProductRepository {
  
  //Bu sınıf, ürün bilgilerini depolamak ve yönetmek için bir depo (repository) işlevi görür. Ürün bilgileri JSON dosyasından yüklenir ve iç bellek (memory) üzerinde yönetilir.
  
  Map<String, ProductInfo> _items = {};
  
  Future<void> init() async {
    final jsonStr = await rootBundle.loadString('assets/data/product_info.json');
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    _items = map.map((k,v) => MapEntry(k,
    ProductInfo(
      id: k,
      displayName: v['displayName'] as String,
      content: v['content'] as String,
      tags: (v['tags'] as List).map((e) => e.toString()).toList(),
    ),
    ));
  }
  ProductInfo? get(String id) => _items[id];

  List<ProductInfo> all() => _items.values.toList();
}