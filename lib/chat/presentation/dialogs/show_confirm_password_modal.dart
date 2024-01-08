import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/chat/presentation/widgets/confirm_password_form.dart';
import 'package:global_chat/user/domain/model/credential.dart';

Future<Credential?> showConfirmPasswordModal(
    BuildContext context, User user) async {
  Credential? res;

  res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConfirmPasswordForm(user: user);
      });
  return res;
}
