// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:chatbot/backend/saving_data.dart';
import 'package:chatbot/component/component.dart';
import 'package:chatbot/pages/homepage_1.dart';
import 'package:chatbot/pages/payment_page.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        Container(
            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 100),
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
                savingUser(textEditingController.text.trim(),
                    textEditingController1.text.trim());
                boxUser.put('islogin', true);
                pushing(context);
                textEditingController.clear();
                textEditingController1.clear();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => PaymentPage()));
            },
            child: const Text(
              'You Can Support Me If you want to',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          )),
        ),
      ]),
    );
  }
}

pushing(context) {
 final route =  MaterialPageRoute(builder: (builder) => HomePage());
  Navigator.pushAndRemoveUntil(context,route,(route) => false);
}
