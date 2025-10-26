// kamera önizleme + "Demo Tespit" butonu
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../core/detection_state.dart';
import '../../core/product_repository.dart';
import '../catalog/product_card.dart';
import 'detection_overlay.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;
    final cameras = await availableCameras();
    final back = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);
    _controller = CameraController(back, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetectionState>();
    final p = state.lastLabel != null
        ? context.read<ProductRepository>().get(state.lastLabel!)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Alışveriş Asistanı (Vize Demo)')),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          const DetectionOverlay(), // mock kutu
          if (p != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ProductCard(product: p, confidence: state.lastConfidence),
            ),
        ],
      ),
      floatingActionButton: _ready
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'demo1',
            onPressed: () => context.read<DetectionState>().setDetection("nescafe_classic"),
            label: const Text('Demo Tespit 1'),
            icon: const Icon(Icons.coffee),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'demo2',
            onPressed: () => context.read<DetectionState>().setDetection("ulker_cizi", conf: 0.93),
            label: const Text('Demo Tespit 2'),
            icon: const Icon(Icons.cookie),
          ),
        ],
      )
          : null,
    );
  }
}
