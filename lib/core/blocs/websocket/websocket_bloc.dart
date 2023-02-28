import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:binance_task/core/blocs/connectivity/connectivity_cubit.dart';
import 'package:binance_task/core/constants/strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

/// [WebSocketBloc]
/// TODO stop websocket on app pause
class WebSocketBloc extends Bloc<SocketEvent, WebsocketState> {
  String streamName = '!miniTicker@arr';
  InternetConnectivityCubit internetConnectivityCubit;
  Timer? _restartTimer;
  WebSocketChannel? _socket;

  WebSocketBloc({
    this.streamName = '!miniTicker@arr',
    required this.internetConnectivityCubit,
  }) : super(WebsocketInitialState()) {
    addInternetSubscription();

    on<SocketOnMessageEvent>((event, emit) {
      // log("WebSocketManager ${event.data}");
      emit(WebsocketMessageState(data: event.data));
    });

    on<SocketErrorEvent>((event, emit) {
      log("WebSocketManager: WebsocketStateDisconnected ${event.data}");
      emit(WebsocketDisconnectedState());
    });

    on<SocketOnDoneEvent>((event, emit) {
      log("WebSocketManager :WebsocketStateDisconnected ${event.data}");
      emit(WebsocketDoneState());
    });
  }

  /// Reload [_socket] on internet connection restored
  void addInternetSubscription() {
    internetConnectivityCubit.stream.listen((event) {
      if (event is ConnectivityResultState) {
        if (event.connectivityResult) {
          _reloadWithDelay();
        }
      }
    });
  }

  /// Starts socket
  /// On [Exception] or [_socket] error  try reload [_socket]
  /// with delay [_reloadWithDelay]
  void startSockets() {
    if (!(internetConnectivityCubit.state as ConnectivityResultState)
        .connectivityResult) {
      return;
    }
    stopSockets();
    try {
      _socket = WebSocketChannel.connect(Uri.parse(
        "${Strings.websocketUrl}$streamName",
      ));
    } catch (e, s) {
      log("WebSocketManager: in catch block error: = $e");
      log("WebSocketManager: Error ${s.toString()}");
      add(SocketErrorEvent("$e $s"));
      _reloadWithDelay();
    }
    log("WebSocketManager: Starting");
    _socket?.stream.listen(
      (message) {
        // log("WebSocketManager: Message {$message}");
        add(SocketOnMessageEvent(json.decode(message)));
      },
      onDone: () {
        if (_socket?.closeCode != null ||
            (_socket?.closeReason?.isNotEmpty ?? false)) {
          log("WebSocketManager: closeReason ${_socket!.closeReason}}");
          log("WebSocketManager: closeCode ${_socket?.closeCode}}");
          _reloadWithDelay();
        }
        add(const SocketOnDoneEvent(null));
        log("WebSocketManager: Done");
      },
      onError: (error) {
        log("WebSocketManager: Error {$error}");
        add(SocketErrorEvent(error));
        _reloadWithDelay();
      },
      cancelOnError: true,
    );
  }

  /// Stop socket, reload timer
  void stopSockets() {
    _restartTimer?.cancel();
    if (_socket != null) {
      log("WebSocketManager: Closing");
      _socket?.sink.close();
      log("WebSocketManager: Closing success");
      _socket = null;
    }
  }

  /// Reload websocket with delay
  void _reloadWithDelay() {
    _restartTimer?.cancel();
    _restartTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      timer.cancel();
      startSockets();
    });
  }

  @override
  Future<void> close() {
    stopSockets();
    return super.close();
  }
}
