part of 'websocket_bloc.dart';

abstract class SocketEvent extends Equatable {
  final dynamic data;

  const SocketEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class SocketOnMessage extends SocketEvent {
  const SocketOnMessage(super.data);
}

class SocketErrorEvent extends SocketEvent {
  const SocketErrorEvent(super.data);
}

class SocketOnDone extends SocketEvent {
  const SocketOnDone(super.data);
}
