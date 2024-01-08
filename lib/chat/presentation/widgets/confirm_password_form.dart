import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:global_chat/user/domain/model/credential.dart';

class ConfirmPasswordForm extends StatefulWidget {

  final User user;

  const ConfirmPasswordForm({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ConfirmPasswordFormState();

}

class _ConfirmPasswordFormState extends State<ConfirmPasswordForm> {

  final tempCredential = Credential();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    tempCredential.email = widget.user.email!;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: verticalPaddingXL,
        left: verticalPaddingXL,
        right: verticalPaddingXL),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
                'Please, confirm your password to start the data deleting process.'),
          ),
          Form(
            key: formKey,
            child: TextFormField(
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
              onChanged: (value) {
                tempCredential.password = value;
              },
              validator: (value) {
                String? validation;
                if (value != null) {
                  if (value.isEmpty) {
                    validation = 'This field is required';
                  } else if (value.length < 8) {
                    validation =
                    'All passwords are 8 characters length min';
                  }
                }
                return validation;
              },
              obscureText: !isPasswordVisible,
              keyboardType: TextInputType.visiblePassword,
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: verticalPadding),
            child: SizedBox(
              width: double.maxFinite,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop(tempCredential);
                  }
                },
                child: const Text("Confirm delete"),
              ),
            ),
          )
        ],
      ),
    ),
  );

}