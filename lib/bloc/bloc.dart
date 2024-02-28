import 'package:flutter_bloc/flutter_bloc.dart';

part './bloc_state.dart';
part 'bloc_event.dart';


class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(InitialState()) {

    on<DataSent>((event, emit) {
     emit(SendingState());
    });

    on<Pending>((event,emit){
      emit(RecievingState());
    });

     on<DataRecieving>((event,emit){
emit(RecievedState());
    });

    on<ImageSelected>((event, emit) {
      emit(ImageSelectedState());
    });
  }
}