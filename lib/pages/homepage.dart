import 'dart:convert';
import 'package:chatbot/main.dart';
import 'package:chatbot/system/auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void dispose() async {
    await Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
    fetchData();
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
    setState(() {});
  }

  fetchData() {
    ChatUser any;

    for (var element in savedMessages) {
      if (me.id.toString() == element[1][0][0].toString()) {
        any = me;
      } else {
        any = bot;
      }
      ChatMessage message = ChatMessage(
          text: element[0],
          user: any,
          createdAt: DateTime.parse(element[1][1]));
      allMessages.insert(0,message);
      setState(() {});
    }
  }

  getdata(ChatMessage message) async {
    allMessages.insert(0, message);
    typing.insert(0, bot);
    setState(() async {
      await savingData(message);
    });
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
    await http
        .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
        .then(
      (value) {
        var result = jsonDecode(value.body);
        var output = result["candidates"][0]['content']['parts'][0]['text'];
        var m = ChatMessage(user: bot, createdAt: DateTime.now(), text: output);
        typing.remove(bot);
        allMessages.insert(0, m);

        setState(() async {
          await savingData(m);
        });
      },
    ).catchError((onError) {
      ChatMessage errorMessage =
          ChatMessage(user: bot, createdAt: DateTime.now());
      allMessages.insert(0, errorMessage);
      setState(() async {
        await savingData(errorMessage);
      });
    });
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
      body: DashChat(
        currentUser: me,
        onSend: getdata,
        messages: allMessages,
        typingUsers: typing,
        messageOptions: messageOptions,
      ),
    );
  }
}
