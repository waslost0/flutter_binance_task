part of 'currency_pair_list_bloc.dart';

enum PostStatus { initial, success, failure }

class CurrencyPairState extends Equatable {
  const CurrencyPairState({
    this.status = PostStatus.initial,
    this.pairs = const <CurrencyPair>[],
  });

  final PostStatus status;
  final List<CurrencyPair> pairs;

  CurrencyPairState copyWith({
    PostStatus? status,
    List<CurrencyPair>? pairs,
    bool? hasReachedMax,
  }) {
    return CurrencyPairState(
      status: status ?? this.status,
      pairs: (updateList(pairs) ?? updateList(this.pairs)) ?? [],
    );
  }

  List<CurrencyPair>? updateList(List<CurrencyPair>? newList) {
    var list = pairs.toList();
    if (newList?.isEmpty ?? true) return list;
    for (var item in newList!) {
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

  @override
  List<Object> get props => [status, pairs];
}
