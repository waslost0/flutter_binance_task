part of 'websocket_bloc.dart';

abstract class SocketEvent extends Equatable {
  final dynamic data;

  const SocketEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class SocketOnMessageEvent extends SocketEvent {
  const SocketOnMessageEvent(super.data);
}

class SocketErrorEvent extends SocketEvent {
  const SocketErrorEvent(super.data);
}

class SocketOnDoneEvent extends SocketEvent {
  const SocketOnDoneEvent(super.data);
}
