import 'dart:async';
import 'dart:developer';

import 'package:binance_task/core/models/websocket/websocket_bloc.dart';
import 'package:binance_task/currency_pair_list/entities/currency.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

part 'currency_pair_list_event.dart';

part 'currency_pair_list_state.dart';

class CurrencyPairListBloc extends Bloc<CurrencyPairEvent, CurrencyPairState> {
  final WebSocketBloc websocketBloc;
  late StreamSubscription websocketSubscription;

  CurrencyPairListBloc({required this.websocketBloc})
      : super(const CurrencyPairState()) {
    addWebsocketSubscription();
    on<CurrencyPairInitEvent>(_init);
    on<CurrencyPairUpdatedEvent>(_onCurrencyUpdate);
    on<CurrencyPairErrorEvent>(_onCurrencyError);
  }

  void _init(
    CurrencyPairInitEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    websocketBloc.startSockets();
  }

  void addWebsocketSubscription() {
    websocketSubscription = websocketBloc.stream.listen((socketState) {
      if (socketState is WebsocketMessageState) {
        var data = parseWebsocketData((socketState).data);
        if (data == null) return;
        add(CurrencyPairUpdatedEvent(pairs: data));
      }
    });
  }

  Future<void> _onCurrencyUpdate(
    CurrencyPairUpdatedEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    try {
      emit(state.copyWith(pairs: event.pairs, status: PostStatus.success));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onCurrencyError(
    CurrencyPairErrorEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    emit(state.copyWith(status: PostStatus.failure));
  }

  @override
  Future<void> close() {
    websocketSubscription.cancel();
    return super.close();
  }

  List<CurrencyPair>? parseWebsocketData(dynamic data) {
    try {
      return (data as List).map((e) => CurrencyPair.fromJson(e)).toList();
    } catch (e, s) {
      add(CurrencyPairErrorEvent("$e\n$s"));
      log("$e\n$s");
    }
    return null;
  }
}
