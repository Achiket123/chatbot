import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_manager.dart';

class MessageBloc extends Cubit<List<ChatMessage>> {
  MessageBloc() : super([]);
  void addMessage(ChatMessage message) {
    var newState = [...state, message];
    emit(newState);
  }

  void loadPreviousMessages(List listofSaveMessages) {
    {
      List<ChatMessage> newState = [];

      // var list = [text,  iSender, createdAt,url, mediaType];
      for (var element in listofSaveMessages) {
        if (element.length == 3) {
          var text = element[0];
          var isSender = element[1];
          var createdAt = element[2].toString();
          ChatMessage message = ChatMessage(
            text: text,
            isSender: isSender,
            createdAt: DateTime.parse(createdAt),
          );
          state.add(message);
        } else {
          var text = element[0];
          var isSender = element[1];
          var createdAt = element[2].toString();
          var url = element[3];
          // var mediaType = element[4];
          print(createdAt);
          ChatMessage message = ChatMessage(
              text: text,
              isSender: isSender,
              createdAt: DateTime.parse(createdAt),
              chatMedia: ChatMedia(
                  url: url, mediaType: const MediaType.imageMediaType()));
          state.add(message);
        }
      }
      newState = state;

      emit(newState);
    }
  }
}

class MediaBloc extends Cubit<List<ChatMedia>> {
  MediaBloc() : super([]);

  void addMedia(ChatMedia media) {
    var newState = [media, ...state];
    emit(newState);
  }
}
