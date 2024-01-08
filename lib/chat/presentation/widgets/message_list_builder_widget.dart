import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/presentation/widgets/date_separator_widget.dart';
import 'package:global_chat/chat/presentation/widgets/message_widget.dart';

class MessageListBuilderWidget extends StatefulWidget {
  final List<Message> messages;
  final User user;
  final ScrollController scrollController;

  const MessageListBuilderWidget(
      {super.key, required this.messages, required this.user, required this.scrollController});

  @override
  State<StatefulWidget> createState() => _MessageListBuilderWidget();
}

class _MessageListBuilderWidget extends State<MessageListBuilderWidget> {
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    buildWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        children: buildWidgets(),
      ),
    );
  }

  List<Widget> buildWidgets() {
    List<Widget> result = [];
    DateTime? lastDateTime;
    for (var message in widget.messages) {
      if (lastDateTime == null) {
        lastDateTime = message.createdDate.toDate();
        result.add(DateSeparatorWidget(date: lastDateTime));
      } else if (message.createdDate.toDate().difference(lastDateTime).inDays >
          0) {
        lastDateTime = message.createdDate.toDate();
        result.add(DateSeparatorWidget(date: lastDateTime));
      }
      result.add(MessageWidget(message: message, user: widget.user));
    }

    return result;
  }
}
