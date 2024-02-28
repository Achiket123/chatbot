import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatbot/main.dart';
import 'package:chatbot/models/user_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/models/chat_model.dart';

Future<ChatModel> getdata(ChatModel message, User Gemini) async {
  late ChatModel chatModel;
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
      chatModel = ChatModel(
          user: Gemini,
          createAt: DateTime.now(),
          text: output,
          isSender: false);
      log(chatModel.text);
    },
  ).catchError((onError) {
    chatModel = ChatModel(
        user: Gemini,
        createAt: DateTime.now(),
        text: 'unable to fetch data',
        isSender: false);
  });
  return chatModel;
}

Future<ChatModel> sendImageData(ChatModel message, User gemin) async {
  ChatModel chatModel=ChatModel(
        text: 'unable to fetch data',
        user: gemin,
        createAt: DateTime.now(),
        isSender: false);

  final gemini = Gemini.instance;
 await gemini.textAndImage(
      text: message.text,
      images: [message.file!.readAsBytesSync()]).then((value) {
        log(value!.content!.parts![0].text.toString());
    chatModel = ChatModel(
        text: value!.content!.parts![0].text.toString(),
        user: gemin,
        createAt: DateTime.now(),
        isSender: false);

  }).catchError((onError) {
    chatModel = ChatModel(
        text: 'unable to fetch data',
        user: gemin,
        createAt: DateTime.now(),
        isSender: false);
  });

  return chatModel;
}
