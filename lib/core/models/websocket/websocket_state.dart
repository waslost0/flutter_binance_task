part of 'websocket_bloc.dart';

abstract class WebsocketState extends Equatable {}

class WebsocketStateInitial extends WebsocketState {
  @override
  List<Object?> get props => [];
}

class WebsocketStateConnected extends WebsocketState {
  @override
  List<Object?> get props => [];
}

class WebsocketStateDisconnected extends WebsocketState {
  @override
  List<Object?> get props => [];
}
