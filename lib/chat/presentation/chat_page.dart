import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_chat/chat/domain/models/message.dart';
import 'package:global_chat/chat/presentation/bloc/chat_bloc.dart';
import 'package:global_chat/chat/presentation/bloc/chat_bloc_constructor.dart';
import 'package:global_chat/chat/presentation/dialogs/show_confirm_password_modal.dart';
import 'package:global_chat/chat/presentation/dialogs/show_confirmation_dialog.dart';
import 'package:global_chat/chat/presentation/widgets/message_bar_widget.dart';
import 'package:global_chat/chat/presentation/widgets/message_list_builder_widget.dart';
import 'package:global_chat/core/constants/images.dart';
import 'package:global_chat/core/constants/links.dart';
import 'package:global_chat/core/extensions/context_extension.dart';
import 'package:global_chat/core/widgets/error_message.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc.dart';
import 'package:global_chat/user/presentation/bloc/user_bloc_constructor.dart';
import 'package:global_chat/user/presentation/sign_in_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/loading_screen.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late BuildContext blocContext;
  ScrollController scrollController = ScrollController();

  final bottomKey = GlobalKey();

  bool isLoading = false;

  final Map<int, String> options = {
    1: 'Privacy policy',
    2: 'Sign out',
    3: 'Delete my data'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Global chat',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return options.keys.map((int index) {
                return PopupMenuItem<int>(
                  value: index,
                  child: Text(options[index]!),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(chatPattern),
                    repeat: ImageRepeat.repeat)),
            child: MultiBlocProvider(
              providers: [
                // provide the chat bloc
                BlocProvider(
                  create: (_) =>
                      chatBlocConstructor()..add(AllMessagesRequested()),
                ),
                // provide the user bloc
                BlocProvider(
                    create: (_) =>
                        userBlocConstructor()..add(GetCurrentUser())),
              ],
              child: MultiBlocListener(
                listeners: [
                  // listen to chat
                  BlocListener<ChatBloc, ChatState>(
                    listener: (BuildContext context, ChatState state) async {
                      setLoading(state.status == ChatStatus.loading);

                      if (state.status == ChatStatus.messageSent) {
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut);
                      }

                      if (state.status == ChatStatus.dataDeleted) {
                        if (widget.user.providerData.first.providerId ==
                            'password') {
                          final userCredential = await showConfirmPasswordModal(context, widget.user);
                          if (mounted && (userCredential != null)) {
                            blocContext.read<UserBloc>().add(
                                DeleteAccountRequested(
                                    userCredential: userCredential));
                          }
                        } else {
                          blocContext.read<UserBloc>().add(
                              DeleteAccountRequested(userCredential: null));
                        }
                      }

                      if ((state.status == ChatStatus.error) && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Oops, something went wrong!')));
                      }
                    },
                  ),
                  // listen to user
                  BlocListener<UserBloc, UserState>(
                      listener: (BuildContext context, UserState state) {
                    setLoading(state.userStatus == UserStatus.loading);
                    if ((state.currentUser == null) &&
                        (state.userStatus == UserStatus.unauthenticated)) {
                      context.navigateTo(const SignInPage());
                    }

                    if (state.userStatus == UserStatus.accountDeleted) {
                      context.navigateTo(const SignInPage());
                    }

                    if (state.userStatus == UserStatus.error) {
                      showErrorMessage(
                          context, state.message ?? "Something went wrong");
                    }
                  })
                ],
                // we don't need to build something for user bloc, only for chat
                child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (BuildContext context, ChatState state) {
                  blocContext = context;
                  return StreamBuilder(
                      stream: state.messages,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Message>> snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            MessageListBuilderWidget(
                                messages: snapshot.data ?? [],
                                user: widget.user,
                                scrollController: scrollController),
                            const MessageBarWidget()
                          ],
                        );
                      });
                }),
              ),
            ),
          ),
          isLoading ? const Loading() : const SizedBox.shrink()
        ],
      ),
    );
  }

  void onMenuItemSelected(int value) async {
    switch (value) {
      case 1:
        await launchUrl(Uri.parse(privacyPolicy));
        break;
      case 2:
        if (await showConfirmationDialog(
                context, 'You\'re about to sign out. Are you sure?') &&
            mounted) {
          blocContext.read<UserBloc>().add(SignOutRequested());
        }
        break;
      case 3:
        if (await showConfirmationDialog(context,
                'You\'re about to PERMANENTLY delete all your messages, your account, and everything associated with you. Are you sure?') &&
            mounted) {
          blocContext.read<ChatBloc>().add(DeleteAllMessagesRequested());
        }
        break;
    }
  }

  void setLoading(bool value) => setState(() {
        isLoading = value;
      });
}
