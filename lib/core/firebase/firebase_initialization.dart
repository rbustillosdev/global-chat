import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  // set the firestore settings
  GetIt.instance<FirebaseFirestore>().settings = const Settings(
    persistenceEnabled: true,
  );
}