import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product_detection.dart';
import '../services/detection_service.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<ProductDetection> _detections = [];

  Future<void> _analyzeImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _detections = [];
    });

    try {
      final result =
      await DetectionService.detectProducts(widget.imagePath);
      setState(() {
        _detections = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Analiz sırasında bir hata oluştu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          // ⬇️ Alt panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const LinearProgressIndicator(
                      color: Colors.redAccent,
                    ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],

                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _isLoading ? null : _analyzeImage,
                    child: const Text(
                      'Ürünleri Algıla',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  if (!_isLoading && _detections.isEmpty)
                    Text(
                      "Herhangi bir ürün algılanamadı.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  if (_detections.isNotEmpty)
                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                        itemCount: _detections.length,
                        itemBuilder: (context, index) {
                          final d = _detections[index];

                          return Container(
                            margin:
                            const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius:
                              BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.redAccent
                                    .withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                // 🧾 Ürün bilgileri
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        d.ingredients,
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (d.confidence > 0)
                                        Text(
                                          "Güven: %${(d.confidence * 100).toStringAsFixed(0)}",
                                          style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.5),
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),


                                Text(
                                  "${d.price.toStringAsFixed(2)} ₺",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
