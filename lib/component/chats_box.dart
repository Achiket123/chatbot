import 'package:chatbot/component/waiting_message.dart';
import 'package:chatbot/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ChatBox extends StatelessWidget {
  ChatModel chatModel;
  ChatBox({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return chatModel.file != null
        ? Align(
            alignment: Alignment.topRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    constraints:
                        const BoxConstraints(maxWidth: 250, minWidth: 40),
                    child: Column(children: [
                      Align(
                          alignment: chatModel.isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: chatModel.isSender
                                    ? Colors.green
                                    : Colors.blue),
                            child: Center(
                                child: Text(chatModel.user.firstName[0])),
                          )),
                      const Padding(padding: EdgeInsets.all(3)),
                      Align(
                          alignment: chatModel.isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              constraints: const BoxConstraints(maxWidth: 250),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: !chatModel.isSender
                                      ? const Color.fromARGB(255, 62, 98, 128)
                                      : const Color.fromARGB(255, 92, 141, 78)),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.file(
                                      chatModel.file!,
                                      fit: BoxFit.cover,
                                      semanticLabel: 'Image',
                                    ),
                                    width: 200,
                                  ),
                                  !chatModel.isSender
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: chatModel.text));
                                            },
                                            icon: const Icon(Icons.copy),
                                            alignment: Alignment.topRight,
                                          ),
                                        )
                                      : const Column(),
                                  Align(
                                    alignment: !chatModel.isSender
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                          color: chatModel.isSender
                                              ? const Color.fromARGB(
                                                  255, 150, 230, 153)
                                              : const Color.fromARGB(
                                                  255, 159, 192, 249),
                                        ),
                                        child: Align(
                                            alignment: chatModel.isSender
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                            child: Text(chatModel.text))),
                                  ),
                                  Text(chatModel.createAt.toString())
                                ],
                              )))
                    ]))
              ]),
            ),
          )
        : chatModel.isWaiting
            ? WaitingMessage()
            : Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                constraints: const BoxConstraints(maxWidth: 250, minWidth: 40),
                child: Column(children: [
                  Align(
                      alignment: chatModel.isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: chatModel.isSender
                                ? Colors.green
                                : Colors.blue),
                        child: Center(child: Text(chatModel.user.firstName[0])),
                      )),
                  const Padding(padding: EdgeInsets.all(3)),
                  Align(
                      alignment: chatModel.isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: !chatModel.isSender
                                  ? const Color.fromARGB(255, 62, 98, 128)
                                  : const Color.fromARGB(255, 92, 141, 78)),
                          child: Column(
                            children: [
                              !chatModel.isSender
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: chatModel.text));
                                        },
                                        icon: const Icon(Icons.copy),
                                        alignment: Alignment.topRight,
                                      ),
                                    )
                                  : const Column(),
                              Align(
                                alignment: !chatModel.isSender
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      color: chatModel.isSender
                                          ? const Color.fromARGB(
                                              255, 150, 230, 153)
                                          : const Color.fromARGB(
                                              255, 159, 192, 249),
                                    ),
                                    child: Align(
                                        alignment: chatModel.isSender
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        child: Text(chatModel.text))),
                              ),
                              Text(chatModel.createAt.toString())
                            ],
                          )))
                ]));
  }
}
