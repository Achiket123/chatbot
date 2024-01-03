import 'dart:convert';
import 'dart:io';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:chatbot/cubit/statemanage.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/pages/imagepage.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chat_package/chat_package.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    initState();
  }

  final ImagePicker picker = ImagePicker();

  List savedMessages = [];

  List<ChatMessage> allMessages = [];

  List<ChatMedia> savedImages = [];

  final box = Hive.box(userData);
  final box2 = Hive.box(boxName);
  get newMethod => box2.get('name');

  getData() {
    return box2.get('name');
  }

  void initState() {
    final data = getData();

    var nalla = box.get('key');

    if (nalla != null) {
      savedMessages = nalla;
    }
    if (savedMessages.isEmpty) {
      firstTime();
    }
  }

  void savingData(ChatMessage message) async {
    if (message.chatMedia != null) {
      var text = message.text;
      var iSender = message.isSender;
      var createdAt = message.createdAt;
      var url = message.chatMedia?.url;
      var mediaType = message.chatMedia?.mediaType.toString();
      var list = [text, iSender, createdAt, url, mediaType];
      savedMessages.add(list);
    } else {
      var text = message.text;
      var iSender = message.isSender;
      var createdAt = message.createdAt;
      var list = [text, iSender, createdAt];
      savedMessages.add(list);
    }

    await box.put('key', savedMessages);
  }

  firstTime() {
    var mess = ChatMessage(
        createdAt: DateTime.now(),
        text: 'Hi I am your Personal Assisstant',
        isSender: false);
    allMessages.insert(0, mess);
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
    print(result);

    var output = result["candidates"] != null
        ? result["candidates"][0]['content']['parts'][0]['text']
        : 'unable to reach';
    return ChatMessage(
        isSender: false, createdAt: DateTime.now(), text: output);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessageBloc>(context).loadPreviousMessages(savedMessages);
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        body: BlocBuilder<MediaBloc, List<ChatMedia>>(
            builder: (context, mediaState) {
          return BlocBuilder<MessageBloc, List<ChatMessage>>(
              builder: (context, state) {
            bool isPhoto = false;
            String? url;
            final gemini = GoogleGemini(
              apiKey: APIKEY,
            );

            final ScrollController scrollController = ScrollController();

            Future<void> getReplyAndAddToBloc(
                ChatMessage message, MessageBloc bloc) async {
              var reply = await getReply(message, bloc);

              print(reply.text);
              bloc.addMessage(reply);

              // bloc.addVoiceMessage(reply);
              savingData(reply);
            }

            return ChatScreen(
              recording: () async {
                final SpeechToText speech = SpeechToText();
                String text = '';

                bool available = await speech.initialize();
                final currentContext = BlocProvider.of<MessageBloc>(context);
                if (available) {
                  await speech.listen(
                      listenFor: Duration(seconds: 3),
                      partialResults: false,
                      onResult: (result) async {
                        text = result.recognizedWords;

                        var audioMessage =
                            ChatMessage(isSender: true, text: text);
                        if (isPhoto) {
                          currentContext.addMessage(audioMessage);
                          var response = await gemini.generateFromTextAndImages(
                              query: audioMessage.text, image: File(url!));
                          var mes = ChatMessage(
                              isSender: false,
                              createdAt: DateTime.now(),
                              text: response.text);
                          currentContext.addMessage(mes);
                          savingData(mes);
                        } else {
                          var m = await getReply(audioMessage, currentContext);

                          currentContext.addMessage(m);
                          savingData(m);
                        }
                      });
                }
              },
              scrollController: scrollController,
              handleImageSelect: (imageMessage) {
                imageMessage!.createdAt = DateTime.now();
                if (imageMessage != null) {
                  isPhoto = true;
                  url = imageMessage.chatMedia!.url;
                  final currentContext = BlocProvider.of<MessageBloc>(context);
                  currentContext.addMessage(imageMessage!);

                  savingData(imageMessage);
                }
              },
              handleRecord: (audioMessage, canceled) async {
                final currentContext = BlocProvider.of<MessageBloc>(context);
                if (audioMessage != null) {
                  if (isPhoto) {
                    isPhoto = false;
                    currentContext.addMessage(audioMessage);
                    print(state);
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    var response = await gemini.generateFromTextAndImages(
                        query: audioMessage.text, image: File(url!));
                    print(response.text);
                    var mes = ChatMessage(
                        isSender: false,
                        createdAt: DateTime.now(),
                        text: response.text);
                    currentContext.addMessage(mes);
                    savingData(mes);
                  } else {
                    var m = await getReply(audioMessage, currentContext);
                    currentContext.addMessage(m);
                    savingData(m);
                  }
                }
              },
              onTextSubmit: (ChatMessage message) async {
                final currentContext = BlocProvider.of<MessageBloc>(context);
                if (isPhoto) {
                  isPhoto = false;
                  currentContext.addMessage(message);
                  print(state);

                  var response = await gemini.generateFromTextAndImages(
                      query: message.text, image: File(url!));
                  print(response.text);
                  var mes = ChatMessage(
                      isSender: false,
                      createdAt: DateTime.now(),
                      text: response.text);
                  currentContext.addMessage(mes);
                  savingData(mes);
                } else {
                  var m = await getReply(message, currentContext);

                  currentContext.addMessage(m);
                  savingData(m);
                }
              },
              messages: state,
            );
          });
        }));
  }
}
