import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class WaitingMessage extends StatelessWidget {
  const WaitingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Column(
        
        children: [
Align(alignment: Alignment.centerLeft,
  child: Container(
              margin: const EdgeInsets.only(left: 10,bottom: 5),

    decoration: BoxDecoration(color: Colors.lightBlue,borderRadius: BorderRadius.circular(30)),width: 20,
    child: const Center(child: Text('G')),),
),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(left: 5),
              width: 250,
              height: 30,
              decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                  const  Text('Gemini is writing'),
                     JumpingDots(innerPadding:5,
                      radius: 5,
                      color: Colors.black,
                      verticalOffset: 5,
                        animationDuration: const Duration(milliseconds: 100)),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}