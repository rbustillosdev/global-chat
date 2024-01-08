import 'package:flutter/material.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:intl/intl.dart';

class DateSeparatorWidget extends StatefulWidget {
  final DateTime date;

  const DateSeparatorWidget({super.key, required this.date});

  @override
  State<StatefulWidget> createState() => _DateSeparatorWidget();
}

class _DateSeparatorWidget extends State<DateSeparatorWidget> {
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(top: verticalMarginXL, bottom: verticalMargin),
          decoration: BoxDecoration(
              color: Colors.grey.withAlpha(75),
              borderRadius: BorderRadius.circular(cornerRadius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(timeTextBuilder()),
          ),
        ));
  }

  String timeTextBuilder() {
    String res = '';
    switch (currentTime.difference(widget.date).inDays) {
      case 0:
        res = 'Today';
        break;
      case 1:
        res = 'Yesterday';
      default:
        res = DateFormat('MMMM dd, yyyy').format(widget.date);
    }
    return res;
  }
}
