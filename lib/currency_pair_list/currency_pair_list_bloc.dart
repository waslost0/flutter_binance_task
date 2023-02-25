import 'dart:async';

import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:bloc/bloc.dart';

import 'currency_pair_list_event.dart';
import 'currency_pair_list_state.dart';

class CurrencyPairListBloc
    extends Bloc<CurrencyPairListEvent, CurrencyPairListState> {
  final WebSocketBloc websocketBloc;
  late StreamSubscription websocketSubscription;

  CurrencyPairListBloc({required this.websocketBloc})
      : super(CurrencyPairListState().init()) {
    websocketSubscription = websocketBloc.stream.listen((state) {
      if (state is SocketOnMessage) {}
    });
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<CurrencyPairListState> emit) async {
    websocketBloc.startSockets();
    emit(state.clone());
  }

  void addWebsocketSubscription() {
    websocketSubscription = websocketBloc.stream.listen((state) {
      if (state is SocketOnMessage) {
        // add(event);
      }
    });
  }

  @override
  Future<void> close() {
    websocketSubscription.cancel();
    return super.close();
  }
}
