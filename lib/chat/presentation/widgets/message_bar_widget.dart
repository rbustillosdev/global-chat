import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/presentation/bloc/chat_bloc.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';

class MessageBarWidget extends StatefulWidget {
  const MessageBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MessageBarWidgetState();
}

class _MessageBarWidgetState extends State<MessageBarWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: horizontalPaddingXS, vertical: verticalPaddingXS),
            child: Container(
              width: double.maxFinite,
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPaddingL),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cornerRadiusXL),
                  color: Colors.grey.shade300),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: 'Message', border: InputBorder.none),
              ),
            ),
          )),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.blueAccent),
            child: IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<ChatBloc>().add(MessageSendRequested(
                      message: Message.asNew(controller.text)));
                  controller.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      );
}
