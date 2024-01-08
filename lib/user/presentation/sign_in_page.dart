import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:global_chat/chat/presentation/chat_page.dart';
import 'package:global_chat/core/constants/firebase_scopes.dart';
import 'package:global_chat/core/constants/icons.dart';
import 'package:global_chat/core/constants/links.dart';
import 'package:global_chat/core/constants/ui_dimensions.dart';
import 'package:global_chat/core/extensions/context_extension.dart';
import 'package:global_chat/core/widgets/error_message.dart';
import 'package:global_chat/user/domain/model/credential.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc_constructor.dart';
import 'package:global_chat/user/presentation/sign_up_page.dart';
import 'package:global_chat/user/presentation/widgets/sign_in_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final firebaseAuth = GetIt.instance<FirebaseAuth>();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: oauthScopes);

  Credential userCredential = Credential();

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
                final textTheme = Theme.of(context).textTheme;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPaddingL),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Hi!', style: textTheme.headlineLarge),
                          Text('Please sign in or register your account to continue', style: textTheme.bodyLarge),
                          const SizedBox(height: verticalPaddingXL),
                          SignInForm(
                              formKey: formKey,
                              onEmailChanged: (value) {
                                userCredential.email = value;
                              },
                              onPasswordChanged: (value) {
                                userCredential.password = value;
                              }),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: verticalPaddingXL),
                            child: RichText(
                              text: TextSpan(
                                style: textTheme.bodyMedium,
                                children: <TextSpan>[
                                  const TextSpan(text: 'Don\'t have an account? '),
                                  TextSpan(
                                      text: 'sign up',
                                      style: const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          context.navigateTo(const SignUpPage(), allowBack: true);
                                        }),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: double.maxFinite,
                              height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<UserBloc>(context).add(
                                          SignInRequested(
                                              userCredential: userCredential));
                                    }
                                  },
                                  child: const Text('Sign in')),
                            ),
                          ),
                          const SizedBox(height: verticalPaddingXL),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding),
                                child: Text('OR'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: verticalPaddingXL),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<UserBloc>(context).add(
                                    SignInRequested(
                                        userCredential: null));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(googleLogo,
                                      width: 25, height: 25),
                                  const SizedBox(width: horizontalPadding),
                                  const Text('Sign in with Google')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: verticalPaddingXL * 3),
                          RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium,
                              children: <TextSpan>[
                                const TextSpan(text: 'Please check the '),
                                TextSpan(
                                    text: 'privacy policy',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launchUrl(
                                            Uri.parse(privacyPolicy));
                                      }),
                              ],
                            ),
                          ),
                          const SizedBox(height: verticalPaddingXL),
                          RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium,
                              children: <TextSpan>[
                                const TextSpan(text: 'Pattern image by '),
                                TextSpan(
                                    text: 'Freepik.com',
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launchUrl(
                                            Uri.parse(freepikImage));
                                      }),
                              ],
                            ),
                          )
                        ],
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
