import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:advanced_hello_world/main.dart';

part 'hello_world_event.dart';
part 'hello_world_state.dart';

class HelloWorldBloc extends Bloc<HelloWorldEvent, HelloWorldState> {
  HelloWorldBloc() : super(HelloWorldInitial());

  String helloWorldString;

  @override
  Stream<HelloWorldState> mapEventToState(
    HelloWorldEvent event,
  ) async* {
    if(event is HelloWorldSetString){
      yield* _helloWorldSetString(event);
    }
  }

  Stream<HelloWorldState> _helloWorldSetString(HelloWorldSetString event) async*{
    helloWorldString = event.helloWorldString ?? HelloWorldStrings.DEFAULT_HELLO_WORLD_STRING;
    HelloWorldMain _state = HelloWorldMain(helloWorldString: helloWorldString);
    yield _state;
  }
}
