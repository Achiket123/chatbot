// ignore_for_file: must_be_immutable

import 'dart:ffi';

import 'package:flutter/material.dart';

class Butt extends StatelessWidget {
  String? text;
  void Function() onpressed;
  Butt({super.key, required this.onpressed, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 61, 132, 255),
          borderRadius: BorderRadius.circular(30)),
      child: TextButton(
        onPressed: onpressed,
        child: Text(
          text!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class Textfield extends StatelessWidget {
  String? text;
  TextEditingController? controller;
  Textfield({super.key, this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromARGB(255, 61, 62, 58)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0)),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  String? text;
  TextEditingController? controller;
  void Function() buttonFunction;
  MessageField(
      {super.key, this.controller, this.text, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(255, 61, 62, 58)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0)),
            ),
          ),
          IconButton(
              onPressed: buttonFunction,
              icon: const Icon(
                Icons.file_copy,
                size: 20,
              ))
        ],
      ),
    );
  }
}
