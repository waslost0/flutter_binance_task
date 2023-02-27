import 'dart:async';
import 'dart:developer';

import 'package:binance_task/core/blocs/websocket/websocket_bloc.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_state.dart';
import 'package:binance_task/currency_pair_list/entities/currency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'currency_pair_list_event.dart';

class CurrencyPairListBloc
    extends HydratedBloc<CurrencyPairEvent, CurrencyPairState> {
  final WebSocketBloc websocketBloc;
  late StreamSubscription websocketSubscription;
  String? searchString;

  CurrencyPairListBloc({required this.websocketBloc})
      : super(const CurrencyPairState()) {
    addWebsocketSubscription();
    on<CurrencyPairInitEvent>(_init);
    on<CurrencyPairUpdatedEvent>(_onCurrencyUpdate);
    on<CurrencyPairErrorEvent>(_onCurrencyError);
    on<CurrencyPairFilterEvent>(_filterCurrencyList, transformer: droppable());
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
      emit(
        state.copyWith(
          pairs: mergeCurrencyList(state.pairs, event.pairs),
          status: PostStatus.success,
        ),
      );
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

  Future<void> _filterCurrencyList(
    CurrencyPairFilterEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    searchString = event.searchString.trim().toLowerCase();
    add(CurrencyPairUpdatedEvent(pairs: state.pairs));
  }

  @override
  Future<void> close() {
    websocketSubscription.cancel();
    return super.close();
  }

  void filterCurrencyList(String searchString) {}

  List<CurrencyPair>? mergeCurrencyList(
    List<CurrencyPair> oldList,
    List<CurrencyPair> newList,
  ) {
    if (searchString?.isNotEmpty ?? false) {
      oldList = oldList
          .where((e) => e.symbol.toLowerCase().contains(searchString!))
          .toList();
      newList = newList
          .where((e) => e.symbol.toLowerCase().contains(searchString!))
          .toList();
    }

    var list = oldList.toList();
    if (newList.isEmpty) return list;
    for (var item in newList) {
      var oldItem = list.firstWhereOrNull((e) => e.symbol == item.symbol);
      if (oldItem != null) {
        var index = list.indexWhere((e) => e.symbol == item.symbol);
        if (index == -1) continue;
        list[index] = item;
      } else {
        list.add(item);
      }
    }
    return list;
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

  @override
  CurrencyPairState? fromJson(Map<String, dynamic> json) =>
      CurrencyPairState.fromJson(json['CurrencyPairState']);

  @override
  Map<String, dynamic>? toJson(CurrencyPairState state) => {
        "CurrencyPairState": state.toJson(),
      };
}
