import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/product_repository.dart';
import 'core/tts_service.dart';
import 'core/detection_state.dart';
import 'features/camera/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // repo & tts init
  final repo = ProductRepository();
  await repo.init();
  final tts = TtsService();

  runApp(MyApp(repo: repo, tts: tts));
}

class MyApp extends StatelessWidget {
  final ProductRepository repo;
  final TtsService tts;
  const MyApp({super.key, required this.repo, required this.tts});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductRepository>.value(value: repo),
        ChangeNotifierProvider<DetectionState>(
          create: (_) => DetectionState(repo: repo, tts: tts),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        home: const CameraScreen(),
      ),
    );
  }
}
