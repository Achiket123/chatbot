import 'dart:io';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chatbot/component/component.dart';
import 'package:chatbot/cubit/statemanage.dart';
import 'package:chatbot/main.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:google_gemini/google_gemini.dart';

// ignore: must_be_immutable
class ImagePage extends StatelessWidget {
  final box = Hive.box(userData);


  Function(ChatMessage message) savingData;
 

  File image;
  ImagePage(
      {super.key,
      required this.image,
      required this.savingData,
     });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return BlocBuilder<MessageBloc, List<ChatMessage>>(
      builder: (context, messagestate) {
        return BlocBuilder<MediaBloc, List<ChatMedia>>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 66, 66, 66),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                title: const Text('Your Image'),
              ),
              body: Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Container(
                          height: 300,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 85, 85, 85),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(image.path),
                                const Icon(Icons.image_rounded),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Textfield(
                            controller: textEditingController,
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              final currentContext =
                                  BlocProvider.of<MessageBloc>(context);
                              Navigator.pop(context);
                              
                              if (textEditingController.text.isNotEmpty) {
                                final gemini = GoogleGemini(
                                  apiKey: APIKEY,
                                );
                                ChatMessage message = ChatMessage(
                                    isSender: true,
                                    createdAt: DateTime.now(),
                                    text: textEditingController.text);
                                currentContext.addMessage(message);

                                savingData(message);
                                var response =
                                    await gemini.generateFromTextAndImages(
                                        query: textEditingController.text,
                                        image: image);
                                print(response.text);

                                message = ChatMessage(
                                    isSender: false,
                                    createdAt: DateTime.now(),
                                    text: response.text);

                                currentContext.addMessage(message);
                                savingData(message);
                                
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blueGrey,
                            ))
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
