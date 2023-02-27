import 'package:binance_task/currency_pair_list/entities/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_pair_list_state.g.dart';

enum PostStatus { initial, success, failure }

@JsonSerializable()
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
  }) {
    return CurrencyPairState(
      status: status ?? this.status,
      pairs: pairs ?? this.pairs,
    );
  }

  @override
  List<Object> get props => [status, pairs];

  factory CurrencyPairState.fromJson(Map<String, dynamic> json) =>
      _$CurrencyPairStateFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyPairStateToJson(this);
}
