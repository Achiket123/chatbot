// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:chatbot/component/component.dart';
import 'package:chatbot/pages/homepage_1.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Login extends StatelessWidget {
  Login({super.key});
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  var output;
  var box = Hive.box(boxName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      body: ListView(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 4),
            child: Image.asset('./assets/gemini.png')),
        const Center(
            child: Text(
          'GEMINI AI',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
        )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Textfield(
            text: 'Enter First Name',
            controller: textEditingController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Textfield(
            text: 'Enter Second Name',
            controller: textEditingController1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Butt(
            text: 'ENTER',
            onpressed: () {
              if (textEditingController.text.isNotEmpty &&
                  textEditingController1.text.isNotEmpty) {
                box.put('name',
                    [textEditingController.text, textEditingController1.text]);
                pushing() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                }

                pushing();
              }
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(
            'MADE FOR CHUTKI, CHUSWANI,PAANI AND PEDOPHILE',
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
          )),
        ),
      ]),
    );
  }
}
