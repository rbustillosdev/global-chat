import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:global_chat/chat/data/models/data_source_constants.dart';
import 'package:global_chat/chat/domain/models/message.dart';

class ChatDataSource {
  final FirebaseFirestore firestore;

  const ChatDataSource({required this.firestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    // just the last 15, I don't wanna get broke ._.
    return firestore
        .collection(chatDatabase)
        .orderBy('created_date', descending: true)
        .limit(15)
        .snapshots();
  }

  Future<void> sendMessage(Message message) async {
    await firestore.collection(chatDatabase).add(message.toMap());
  }

  Future<void> deleteAllMessages(User user) async {
    await firestore
        .collection(chatDatabase)
        .where('sender_email', isEqualTo: user.email)
        .get()
        .then((snapshot) async {
      for (var document in snapshot.docs) {
        await document.reference.delete();
      }
    });
  }
}
