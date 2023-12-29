import 'package:chatbot/pages/homepage.dart';
import 'package:chatbot/pages/login.dart';
import 'package:chatbot/system/auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

const APIKEY = '';
void main() async {
  await Hive.initFlutter();
  await Hive.openBox(boxName);
  await Hive.openBox(userData);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Hive.box(boxName).values.isEmpty ? Login() : const HomePage());
  }
}
