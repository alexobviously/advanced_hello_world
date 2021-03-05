import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

void main() {
  runApp(HelloWorldApp());
}

class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HelloWorldBloc>(
          lazy: false,
          create: (context) => HelloWorldBloc()..add(
              HelloWorldSetString(
                helloWorldString: String.fromEnvironment(
                  'HELLO_WORLD_STRING',
                  defaultValue: HelloWorldStrings.DEFAULT_HELLO_WORLD_STRING,
                )
              )
          ),
        ),
      ],
      child: MaterialApp(
        title: HelloWorldStrings.HELLO_WORLD_TITLE,
        theme: ThemeData(
          primarySwatch: HelloWorldColours.MAIN_COLOUR,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: HelloWorldColours.TEXT_COLOUR,
            ),
          ),
        ),
        home: HelloWorldHomePage(
          helloWorldAppBarTitle: HelloWorldStrings.HELLO_WORLD_APP_BAR_TITLE,
        ),
      ),
    );
  }
}

class HelloWorldHomePage extends StatefulWidget {
  HelloWorldHomePage({Key key, this.helloWorldAppBarTitle}) : super(key: key);

  final String helloWorldAppBarTitle;

  @override
  _HelloWorldHomePageState createState() => _HelloWorldHomePageState();
}

class _HelloWorldHomePageState extends State<HelloWorldHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.helloWorldAppBarTitle),
      ),
      body: HelloWorldMainContent(),
    );
  }
}

class HelloWorldMainContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelloWorldBloc, HelloWorldState>(
      builder: (context, state){
        if(state is HelloWorldMain){
          return SafeArea(
            child: Center(
              child: Text(
                state.helloWorldString,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }
        else{
          if(!(state is HelloWorldInitial || state is HelloWorldLoading)) {
            HelloWorldBloc helloWorldBloc = BlocProvider.of<HelloWorldBloc>(
                context);
            helloWorldBloc.add(HelloWorldSetString(
              helloWorldString: HelloWorldStrings.HELLO_WORLD_ERROR,
            ));
            helloWorldBloc.close();
          }
          return SafeArea(
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

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

abstract class HelloWorldEvent extends Equatable {
  const HelloWorldEvent();
}

class HelloWorldSetString extends HelloWorldEvent{
  final String helloWorldString;

  HelloWorldSetString({this.helloWorldString});

  @override
  List<Object> get props => [helloWorldString];
}

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

class HelloWorldStrings{
  static const HELLO_WORLD_TITLE = 'Hello World';
  static const HELLO_WORLD_APP_BAR_TITLE = 'Hello World';
  static const DEFAULT_HELLO_WORLD_STRING = 'Hello World';
  static const HELLO_WORLD_ERROR = 'Error Greeting World';
}

class HelloWorldColours{
  static const MAIN_COLOUR = Colors.blue;
  static const TEXT_COLOUR = Colors.deepPurple;
}