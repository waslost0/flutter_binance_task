part of 'websocket_bloc.dart';

abstract class WebsocketState extends Equatable {
  final dynamic data;

  const WebsocketState({this.data});

  @override
  List<Object?> get props => [data];
}

class WebsocketInitialState extends WebsocketState {}

class WebsocketDisconnectedState extends WebsocketState {}

class WebsocketMessageState extends WebsocketState {
  const WebsocketMessageState({super.data});
}

class WebsocketDoneState extends WebsocketState {}
