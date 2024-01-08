import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 10,
            ),
          ),
        ),
      );
}
