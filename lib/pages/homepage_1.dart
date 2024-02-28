import 'dart:developer';
import 'dart:io';
import 'package:chatbot/backend/send_message.dart';
import 'package:chatbot/bloc/bloc.dart';
import 'package:chatbot/component/chats_box.dart';
import 'package:chatbot/component/component.dart';
import 'package:chatbot/models/chat_model.dart';
import 'package:chatbot/models/user_model.dart';
import 'package:chatbot/pages/image_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  User user1 = User(firstName: 'Chutki', userID: '1');
  User Gemini = User(firstName: 'Gemini', userID: '2');
  bool isWriting = false;
 
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  List TextMessages = [];
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gemini"),
          foregroundColor: Colors.white,
          leading: Container(
            child: Image.asset('./assets/gemini.png'),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                if (state is InitialState) {
                  log('!');
                  return ListView.builder(
                      controller: _scroll,
                      itemCount: TextMessages.length,
                      itemBuilder: (context, index) {
                        return ChatBox(
                          chatModel: TextMessages[index],
                        );
                      });
                }else if (state is SendingState) {
                  log('!');
                  return ListView.builder(
                      controller: _scroll,
                      itemCount: TextMessages.length,
                      itemBuilder: (context, index) {
                        return ChatBox(
                          chatModel: TextMessages[index],
                        );
                      });
                
                
                } else if (state is RecievingState) {
                   log('@');
                   ChatModel chatModel = ChatModel(text: 'text', user: Gemini, createAt: DateTime.now(),isWaiting: true,isSender: false);
                   TextMessages.add(chatModel);
                  return  ListView.builder(
                            controller: _scroll,
                            itemCount: TextMessages.length,
                            itemBuilder: (context, index) {
                               _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                              return ChatBox(
                                chatModel: TextMessages[index],
                              );
                            });
                  
                } else if (state is RecievedState) {

                  if(TextMessages.length>2){
                  TextMessages.removeAt(TextMessages.length-2);}
                  log('#');
                 return ListView.builder(
                      controller: _scroll,
                      itemCount: TextMessages.length,
                      itemBuilder: (context, index) {
                         _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                        return ChatBox(
                          chatModel: TextMessages[index],
                        );
                        
                      });
                }
                
                  return ListView.builder(
                      controller: _scroll,
                      itemCount: TextMessages.length,
                      itemBuilder: (context, index) {
                         _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                        return ChatBox(
                          chatModel: TextMessages[index],
                        );
                      });
                
              })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: MessageField(
                      buttonFunction: () async {

                        FilePickerResult? result = await FilePicker.platform.pickFiles();

if (result != null ) {
  File  file = File(result.files.single.path!);
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ImagePage(file: file,
    buttonFunction: ()async{

final blocContext = BlocProvider.of<MessageBloc>(context);
                          if (_controller.text.trim().isNotEmpty && !isWriting)  {
                            Navigator.pop(context);
                            isWriting=true;
                            ChatModel message = ChatModel(
                              createAt: DateTime.now(),
                              text: _controller.text.trim(),
                              user: user1,
                              file: file
                            );
                            _controller.clear();
                            TextMessages.add(message);
                            BlocProvider.of<MessageBloc>(context)
                                .add(DataSent());

                                 _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                          log(TextMessages.toString());
                            
                            BlocProvider.of<MessageBloc>(context)
                                .add(Pending());
                                
                            TextMessages.add(await sendImageData(message, Gemini));
                                log(TextMessages.toString());
 
                                blocContext.add(DataRecieving());

                          }
                          isWriting=false;
                         


    }, controller: _controller,))));

} else {
  // User canceled the picker
}
                      },
                      text: "Enter Message...",
                      controller: _controller,
                    )),
                    IconButton(
                        onPressed:()async{
                          final blocContext = BlocProvider.of<MessageBloc>(context);
                          if (_controller.text.trim().isNotEmpty && !isWriting)  {
                            isWriting=true;
                            ChatModel message = ChatModel(
                              createAt: DateTime.now(),
                              text: _controller.text.trim(),
                              user: user1,
                            );
                            _controller.clear();
                            TextMessages.add(message);
                            BlocProvider.of<MessageBloc>(context)
                                .add(DataSent());

                                 _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                          log(TextMessages.toString());
                            
                            BlocProvider.of<MessageBloc>(context)
                                .add(Pending());
                                
                            TextMessages.add(await getdata(message, Gemini));
                                log(TextMessages.toString());
 
                                blocContext.add(DataRecieving());

                          }
                          isWriting=false;
                         



                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ));
  }

void simpleFunc(context)async{
   final blocContext = BlocProvider.of<MessageBloc>(context);
                          if (_controller.text.trim().isNotEmpty && !isWriting)  {
                            isWriting=true;
                            ChatModel message = ChatModel(
                              createAt: DateTime.now(),
                              text: _controller.text.trim(),
                              user: user1,
                            );
                            _controller.clear();
                            TextMessages.add(message);
                            BlocProvider.of<MessageBloc>(context)
                                .add(DataSent());

                                 _scroll.animateTo(_scroll.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeOut);
                          log(TextMessages.toString());
                            
                            BlocProvider.of<MessageBloc>(context)
                                .add(Pending());
                                
                            TextMessages.add(await getdata(message, Gemini));
                                log(TextMessages.toString());
 
                                blocContext.add(DataRecieving());

                          }
                          isWriting=false;
                         
}


}
