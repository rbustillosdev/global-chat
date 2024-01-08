import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:global_chat/core/constants/environment.dart';
import 'package:global_chat/core/firebase/firebase_initialization.dart';
import 'package:global_chat/core/firebase/firebase_options.dart';
import 'package:global_chat/core/injection/app_module.dart';
import 'package:global_chat/user/presentation/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: envFile);
  final firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await executeInjection(firebaseApp);
  await setupFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
    );
  }
}