import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_manager.dart';

class MessageBloc extends Cubit<List<ChatMessage>> {
  MessageBloc() : super([]);
  void addMessage(ChatMessage message) {
    emit([message, ...state]);
  }

  void loadPreviousMessages(
      List listofSaveMessages, ChatUser me, ChatUser bot) {
    ChatUser any;

    List<ChatMessage> newState = [];
    for (var element in listofSaveMessages) {
      if (me.id.toString() == element[1][0][0].toString()) {
        any = me;
      } else {
        any = bot;
      }
      ChatMessage message = ChatMessage(
          text: element[0],
          user: any,
          createdAt: DateTime.parse(element[1][1]));
      state.insert(0, message);
    }
    newState = state;

    emit(newState);
  }

  void addVoiceMessage(ChatMessage message) {
    var newState = [message, ...state];
    emit(newState);
  }
}
