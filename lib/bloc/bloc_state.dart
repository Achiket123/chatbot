part of './bloc.dart';

class MessageState{}

class InitialState extends MessageState{

  InitialState();
}

class SendingState extends MessageState {
   SendingState();
}



class RecievingState extends MessageState {
   RecievingState();
}


class RecievedState extends MessageState {
   RecievedState();
}

class ImageSelectedState extends MessageState{
  ImageSelectedState();
}