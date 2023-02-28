import 'dart:async';
import 'dart:developer';

import 'package:binance_task/core/blocs/websocket/websocket_bloc.dart';
import 'package:binance_task/currency_pair_list/currency_pair_list_state.dart';
import 'package:binance_task/currency_pair_list/entities/currency.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'currency_pair_list_event.dart';

/// https://api4.binance.com/api/v3/ticker/24hr
/// TODO: load all currencies before update websocket
class CurrencyPairListBloc
    extends HydratedBloc<CurrencyPairEvent, CurrencyPairState> {
  final WebSocketBloc websocketBloc;
  late StreamSubscription websocketSubscription;

  List<CurrencyPair> allLoaded = [];

  String searchString = "";

  CurrencyPairListBloc({
    required this.websocketBloc,
  }) : super(const CurrencyPairState()) {
    on<CurrencyPairInitEvent>(_init);
    on<CurrencyPairUpdatedEvent>(_onCurrencyUpdate);
    on<CurrencyPairErrorEvent>(_onCurrencyError);
    on<CurrencyPairFilterEvent>(_onSearchCurrencyList,
        transformer: droppable());
  }

  void _init(
    CurrencyPairInitEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    websocketSubscription = websocketBloc.stream.listen((socketState) {
      if (socketState is WebsocketMessageState) {
        var data = parseWebsocketData((socketState).data);
        if (data == null) return;
        add(CurrencyPairUpdatedEvent(pairs: data));
      }
    });
    allLoaded = state.pairs;
    websocketBloc.startSockets();
  }

  Future<void> _onCurrencyUpdate(
    CurrencyPairUpdatedEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    try {
      allLoaded = mergeCurrencyList(
            allLoaded,
            event.pairs,
            shouldFilter: false,
          ) ??
          allLoaded;
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

  Future<void> _onSearchCurrencyList(
    CurrencyPairFilterEvent event,
    Emitter<CurrencyPairState> emit,
  ) async {
    if (searchString == event.searchString) {
      return;
    }
    add(CurrencyPairUpdatedEvent(pairs: allLoaded));
    searchString = event.searchString;
  }

  List<CurrencyPair>? mergeCurrencyList(
    List<CurrencyPair> oldList,
    List<CurrencyPair> newList, {
    bool shouldFilter = true,
  }) {
    if (searchString.isNotEmpty && shouldFilter) {
      oldList = allLoaded
          .where((e) => e.symbol.toLowerCase().contains(searchString))
          .toList();
      newList = newList
          .where((e) => e.symbol.toLowerCase().contains(searchString))
          .toList();
    } else {
      oldList = allLoaded.toList();
    }

    if (newList.isEmpty) return oldList;
    for (var item in newList) {
      var oldItem = oldList.firstWhereOrNull((e) => e.symbol == item.symbol);
      if (oldItem != null) {
        var index = oldList.indexWhere((e) => e.symbol == item.symbol);
        if (index == -1) continue;
        oldList[index] = item;
      } else {
        oldList.add(item);
      }
    }
    return oldList;
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
  Future<void> close() {
    websocketSubscription.cancel();
    return super.close();
  }

  @override
  CurrencyPairState? fromJson(Map<String, dynamic> json) =>
      CurrencyPairState.fromJson(json['CurrencyPairState']);

  @override
  Map<String, dynamic>? toJson(CurrencyPairState state) => {
        "CurrencyPairState": state.toJson(),
      };
}
