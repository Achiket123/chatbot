part of './bloc.dart';

class MessageEvent{}


class DataSent extends MessageEvent{
   DataSent();
}



class DataRecieving extends MessageEvent{
   DataRecieving();
}



class Pending extends MessageEvent{
   Pending();
}

class ImageSelected extends MessageEvent{
  ImageSelected();
}