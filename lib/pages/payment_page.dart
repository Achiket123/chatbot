import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PaymentPage extends StatelessWidget {
  PaymentPage({super.key});

  double amount = 0.0;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image.asset(
              './assets/upi.jpg',
              height: 250,
              width: 250,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(0, 33, 149, 243)),
              child: const Text(
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15,
                  color: Colors.grey,
                ),
                'achiket.9678@wahdfcbank',
              ),
            ),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  Clipboard.setData(
                      const ClipboardData(text: 'achiket.9678@wahdfcbank'));
                },
                child: const Icon(Icons.copy)),
          ),
          const Center(
            child: Text(
              "IF YOU WANT TO HELP ME MAINTAIN THIS PROJECT YOU CAN SCAN THIS QR CODE AND SUPPORT ME !!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(86, 158, 158, 158),
                decoration: TextDecoration.none,
                fontSize: 30,
              ),
            ),
          ),
          const CloseButton()
        ],
      ),
    );
  }
}
