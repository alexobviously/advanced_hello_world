part of 'hello_world_bloc.dart';

abstract class HelloWorldState extends Equatable {
  const HelloWorldState();

  @override
  List<Object> get props => [];
}

class HelloWorldInitial extends HelloWorldState {}
class HelloWorldLoading extends HelloWorldState {}

class HelloWorldMain extends HelloWorldState{
  final String helloWorldString;

  HelloWorldMain({this.helloWorldString});

  @override
  List<Object> get props => [helloWorldString];
}