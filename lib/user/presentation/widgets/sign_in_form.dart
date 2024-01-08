import 'package:flutter/material.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:global_chat/core/extensions/string_extension.dart';

class SignInForm extends StatefulWidget {
  final GlobalKey formKey;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;

  const SignInForm(
      {super.key,
      required this.formKey,
      required this.onEmailChanged,
      required this.onPasswordChanged});

  @override
  State<StatefulWidget> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) => Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: widget.onEmailChanged,
              validator: (value) {
                String? validation;
                if (value != null) {
                  if (value.isEmpty) {
                    validation = 'This field is required';
                  } else if (!value.isValidEmail()) {
                    validation = 'This is not a valid email';
                  }
                }
                return validation;
              },
            ),
            const SizedBox(height: verticalPaddingXL),
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Password'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              onChanged: widget.onPasswordChanged,
              validator: (value) {
                String? validation;
                if (value != null) {
                  if (value.isEmpty) {
                    validation = 'This field is required';
                  }
                }
                return validation;
              },
              obscureText: !isPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
            )
          ],
        ),
      );
}
