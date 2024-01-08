import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_chat/chat/presentation/chat_page.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:global_chat/core/extensions/context_extension.dart';
import 'package:global_chat/core/extensions/string_extension.dart';
import 'package:global_chat/core/widgets/error_message.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc_constructor.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late BuildContext blocContext;

  Credential userCredential = Credential();

  final formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          create: (_) => userBlocConstructor()
            ..add(GetCurrentUser()),
          child: BlocListener<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {

              setLoading(state.userStatus == UserStatus.loading);

              if (state.userStatus == UserStatus.authenticated) {
                context.navigateTo(ChatPage(user: state.currentUser!));
              }
              if (state.userStatus == UserStatus.error) {
                showErrorMessage(context, state.message ?? "Unknown error");
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (BuildContext context, UserState state) {
                blocContext = context;
                final textTheme = Theme.of(context).textTheme;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPaddingL),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Sign up', style: textTheme.headlineLarge),
                            const SizedBox(height: verticalPaddingXL),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Username'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                userCredential.displayName = value;
                              },
                              validator: (value) {
                                String? validation;
                                if (value != null) {
                                  if (value.isEmpty) {
                                    validation = 'This field is required';
                                  }
                                }
                                return validation;
                              },
                            ),
                            const SizedBox(height: verticalPaddingXL),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Email'),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                userCredential.email = value;
                              },
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
                              onChanged: (value) {
                                userCredential.password = value;
                              },
                              validator: (value) {
                                String? validation;
                                if (value != null) {
                                  if (value.isEmpty) {
                                    validation = 'This field is required';
                                  } else if (!value.isStrongPassword()) {
                                    validation =
                                        'The password should contain at least'
                                            '\n1 uppercase letter,'
                                            '\n1 lowercase letter,'
                                            '\n1 number,'
                                            '\n1 special character,'
                                            '\nand must be at least 8 characters long.';
                                  }
                                }
                                return validation;
                              },
                              obscureText: !isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: verticalPaddingXL),
                            TextFormField(
                              decoration: InputDecoration(
                                label: const Text('Confirm password'),
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
                              validator: (value) {
                                String? validation;
                                if (value != null) {
                                  if (value.isEmpty) {
                                    validation = 'This field is required';
                                  } else if (value != userCredential.password) {
                                    validation = 'Password does not match';
                                  }
                                }
                                return validation;
                              },
                              obscureText: !isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: verticalPaddingXL),
                            SizedBox(
                              width: double.maxFinite,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    blocContext.read<UserBloc>().add(
                                        SignUpRequested(
                                            userCredential: userCredential));
                                  }
                                },
                                child: const Text('Register'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  void setLoading(bool value) => setState(() {
    isLoading = value;
  });
}
