import 'dart:convert';
import 'package:chatbot/cubit/statemanage.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    initState();
  }

  List<ChatUser> typing = [];

  List savedMessages = [];

  List<ChatMessage> allMessages = [];

  final box = Hive.box(userData);
  final box2 = Hive.box(boxName);
  get newMethod => box2.get('name');
  late ChatUser me;
  late ChatUser bot;

  getData() {
    return box2.get('name');
  }

  void initState() {
    final data = getData();
    me = ChatUser(
      id: '1',
      firstName: data[0],
      lastName: data[1],
    );
    bot = ChatUser(id: '2', firstName: 'Gemini', lastName: 'AI');
    var nalla = box.get('key');

    if (nalla != null) {
      savedMessages = nalla;
    }
    if (savedMessages.isEmpty) {
      firstTime();
    }
  }

  savingData(ChatMessage message) async {
    var text = message.text;
    var user = [message.user.id, message.user.firstName, message.user.lastName];
    var time = message.createdAt.toString();
    savedMessages.add([
      text,
      [user, time]
    ]);

    await box.put('key', savedMessages);
  }

  firstTime() {
    var mess = ChatMessage(
        createdAt: DateTime.now(),
        text: 'Hi ${me.firstName} I am your Personal Assisstant',
        user: bot);
    allMessages.insert(0, mess);
    // setState(() {});
  }

  getReply(ChatMessage message, MessageBloc currentContext) async {
    currentContext.addMessage(message);
    const headers = {'Content-Type': 'application/json'};
    const url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$APIKEY";

    var body = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };
    var value = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    var result = jsonDecode(value.body);
    var output = result["candidates"][0]['content']['parts'][0]['text'];
    return ChatMessage(user: bot, createdAt: DateTime.now(), text: output);
  }

  MessageOptions messageOptions = const MessageOptions(
      currentUserTextColor: Colors.black,
      showCurrentUserAvatar: true,
      currentUserContainerColor: Color.fromARGB(255, 188, 188, 188),
      containerColor: Color.fromARGB(255, 88, 88, 88));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        body: BlocBuilder<MessageBloc, List<ChatMessage>>(
            builder: (context, state) {
          BlocProvider.of<MessageBloc>(context)
              .loadPreviousMessages(savedMessages, me, bot);
          return DashChat(
            currentUser: me,
            onSend: (ChatMessage message) async {
              final currentContext = BlocProvider.of<MessageBloc>(context);
              typing.add(bot);
              await savingData(message);
              var m = await getReply(message, currentContext);

              typing.remove(bot);

              currentContext.addMessage(m);
              await savingData(m);
            },
            messages: state,
            typingUsers: typing,
            messageOptions: messageOptions,
          );
        }));
  }
}
