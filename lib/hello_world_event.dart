part of 'hello_world_bloc.dart';

abstract class HelloWorldEvent extends Equatable {
  const HelloWorldEvent();
}

class HelloWorldSetString extends HelloWorldEvent{
  final String helloWorldString;

  HelloWorldSetString({this.helloWorldString});

  @override
  List<Object> get props => [helloWorldString];
}