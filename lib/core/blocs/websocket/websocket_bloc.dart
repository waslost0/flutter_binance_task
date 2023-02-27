import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:binance_task/core/blocs/connectivity/connectivity_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/io.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

class WebSocketBloc extends Bloc<SocketEvent, WebsocketState> {
  static const String webSocketUrl = 'wss://stream.binance.com:9443/ws/';
  static const String streamName = '!miniTicker@arr';

  late StreamSubscription internetSubscription;
  InternetConnectivityCubit internetConnectivityCubit;

  Timer? _restartTimer;

  IOWebSocketChannel? _socket;

  WebSocketBloc({
    required this.internetConnectivityCubit,
  }) : super(WebsocketInitialState()) {
    addInternetSubscription();

    on<SocketOnMessageEvent>((event, emit) {
      // log("SocketConnect ${event.data}");
      emit(WebsocketMessageState(data: event.data));
    });

    on<SocketErrorEvent>((event, emit) {
      log("WebsocketStateDisconnected ${event.data}");
      emit(WebsocketDisconnectedState());
    });

    on<SocketOnDoneEvent>((event, emit) {
      log("WebsocketStateDisconnected ${event.data}");
      emit(WebsocketDoneState());
    });
  }

  void addInternetSubscription() {
    internetSubscription = internetConnectivityCubit.stream.listen((event) {
      if (event is ConnectivityResultState) {
        if (event.connectivityResult == false) {
          _reloadWithDelay();
        }
      }
    });
  }

  void startSockets() {
    stopSockets();
    try {
      _socket = IOWebSocketChannel.connect(
        "$webSocketUrl$streamName",
        pingInterval: const Duration(seconds: 2),
      );
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

  void stopSockets() {
    _restartTimer?.cancel();
    if (_socket != null) {
      log("WebSocketManager: Closing");
      _socket?.sink.close();
      log("WebSocketManager: Closing success");
      _socket = null;
    }
  }

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
