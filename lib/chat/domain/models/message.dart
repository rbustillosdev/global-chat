import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  Timestamp createdDate;
  Timestamp modifiedDate;
  String documentId;
  String sender;
  String senderEmail;

  Message(
      {required this.message,
      required this.createdDate,
      required this.documentId,
      required this.modifiedDate,
      required this.sender,
      required this.senderEmail});

  factory Message.fromMap(DocumentSnapshot document) => Message(
      documentId: document.id,
      message: document['message'],
      sender: document['sender'] ?? 'User',
      createdDate: document['created_date'],
      modifiedDate: document['modified_date'],
      senderEmail: document['sender_email']);

  Map<String, dynamic> toMap() => {
        'message': message,
        'sender': sender,
        'created_date': createdDate,
        'modified_date': modifiedDate,
        'sender_email': senderEmail,
      };

  factory Message.asNew(String message) => Message(
      message: message,
      createdDate: Timestamp.now(),
      documentId: "",
      modifiedDate: Timestamp.now(),
      sender: "",
      senderEmail: "");

  Message copyWith(
          {String? message,
          Timestamp? createdDate,
          Timestamp? modifiedDate,
          String? documentId,
          String? sender,
          String? senderEmail}) =>
      Message(
          message: message ?? this.message,
          createdDate: createdDate ?? this.createdDate,
          modifiedDate: modifiedDate ?? this.modifiedDate,
          documentId: documentId ?? this.documentId,
          sender: sender ?? this.sender,
          senderEmail: senderEmail ?? this.senderEmail);
}
