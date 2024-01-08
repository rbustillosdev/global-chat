import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:global_chat/core/extensions/timestamp_extension.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final User user;

  const MessageWidget({super.key, required this.message, required this.user});

  @override
  State<StatefulWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: isSameUser() ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.8),
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
              color:
                  isSameUser() ? Colors.green.shade300 : Colors.blue.shade300,
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornerRadius))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle, size: 20),
                  const SizedBox(width: horizontalPaddingXS),
                  Text(isSameUser() ? 'Me' : widget.message.sender,
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
              Text(widget.message.message),
              Text(widget.message.createdDate.toHumanTime(),
                  style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ),
      ),
    );
  }

  bool isSameUser() => widget.user.email == widget.message.senderEmail;
}
