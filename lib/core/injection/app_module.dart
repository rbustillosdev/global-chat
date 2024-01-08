import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:global_chat/core/injection/chat_module.dart';
import 'package:global_chat/core/injection/user_module.dart';

Future<void> executeInjection(FirebaseApp firebaseApp) async {
  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instanceFor(app: firebaseApp));

  // user module
  await injectUserModule(getIt);

  // chat module
  await injectChatModule(getIt);
}