// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyPair _$CurrencyPairFromJson(Map<String, dynamic> json) => CurrencyPair(
      eventType: json['e'] as String,
      eventTime: const DateTimeJsonConverter().fromJson(json['E'] as int),
      symbol: json['s'] as String,
      closePrice: json['c'] as String,
      openPrice: json['o'] as String,
      highPrice: json['h'] as String,
      lowPrice: json['l'] as String,
      totalTradedBaseAssetVolume: json['v'] as String,
      totalTradedQuoteAssetVolume: json['q'] as String,
    );

Map<String, dynamic> _$CurrencyPairToJson(CurrencyPair instance) =>
    <String, dynamic>{
      'e': instance.eventType,
      'E': const DateTimeJsonConverter().toJson(instance.eventTime),
      's': instance.symbol,
      'c': instance.closePrice,
      'o': instance.openPrice,
      'h': instance.highPrice,
      'l': instance.lowPrice,
      'v': instance.totalTradedBaseAssetVolume,
      'q': instance.totalTradedQuoteAssetVolume,
    };
