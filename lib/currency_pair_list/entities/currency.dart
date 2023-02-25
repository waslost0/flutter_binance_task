import 'package:binance_task/core/helpers/custom_json_converters.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class CurrencyPair extends Equatable {
  @JsonKey(name: "e")
  final String eventType;
  @JsonKey(name: "E")
  final DateTime eventTime;

  // "e": "aggTrade",  // Event type
  // "E": 123456789,   // Event time
  // "s": "BNBBTC",    // Symbol
  // "a": 12345,       // Aggregate trade ID
  // "p": "0.001",     // Price
  // "q": "100",       // Quantity
  // "f": 100,         // First trade ID
  // "l": 105,         // Last trade ID
  // "T": 123456785,   // Trade time
  // "m": true,        // Is the buyer the market maker?
  // "M": true         // Ignore

  const CurrencyPair({
    required this.eventType,
    required this.eventTime,
  });

  factory CurrencyPair.fromJson(Map<String, dynamic> json) =>
      _$CurrencyPairFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyPairToJson(this);

  @override
  List<Object?> get props => [];
}
