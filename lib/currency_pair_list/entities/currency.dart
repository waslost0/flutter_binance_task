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
  @JsonKey(name: "s")
  final String symbol;
  @JsonKey(name: "c")
  final String closePrice;
  @JsonKey(name: "o")
  final String openPrice;
  @JsonKey(name: "h")
  final String highPrice;
  @JsonKey(name: "l")
  final String lowPrice;
  @JsonKey(name: "v")
  final String totalTradedBaseAssetVolume;
  @JsonKey(name: "q")
  final String totalTradedQuoteAssetVolume;

  const CurrencyPair({
    required this.eventType,
    required this.eventTime,
    required this.symbol,
    required this.closePrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.totalTradedBaseAssetVolume,
    required this.totalTradedQuoteAssetVolume,
  });

  factory CurrencyPair.fromJson(Map<String, dynamic> json) =>
      _$CurrencyPairFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyPairToJson(this);

  @override
  List<Object?> get props => [
        eventType,
        eventTime,
        symbol,
        closePrice,
        openPrice,
        highPrice,
        lowPrice,
        totalTradedBaseAssetVolume,
        totalTradedBaseAssetVolume,
      ];

  double get openPriceValue => double.tryParse(openPrice) ?? 0.0;
  double get closePriceValue => double.tryParse(closePrice) ?? 0.0;
}
