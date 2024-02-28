import 'dart:io';

import 'package:chatbot/models/user_model.dart';

class ChatModel {
  bool isWaiting;
  String text;
  File? file;
  DateTime createAt;
  bool isSender;
  User user;
  ChatModel(
      {this.isWaiting=false,required this.text,
      required this.user,
      this.isSender = true,
      required this.createAt,
      this.file});
}
