part of 'statemanage.dart';

sealed class AllEvents {}

sealed class AddMessages extends AllEvents {
  AddMessages(ChatMessage message);
}

sealed class AddImages extends AllEvents {
  AddImages(ChatMedia media);
}
