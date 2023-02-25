// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyPair _$CurrencyPairFromJson(Map<String, dynamic> json) => CurrencyPair(
      eventType: json['e'] as String,
      eventTime: const DateTimeJsonConverter().fromJson(json['E'] as int),
    );

Map<String, dynamic> _$CurrencyPairToJson(CurrencyPair instance) =>
    <String, dynamic>{
      'e': instance.eventType,
      'E': const DateTimeJsonConverter().toJson(instance.eventTime),
    };
