// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_pair_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyPairState _$CurrencyPairStateFromJson(Map<String, dynamic> json) =>
    CurrencyPairState(
      status: $enumDecodeNullable(_$PostStatusEnumMap, json['status']) ??
          PostStatus.initial,
      pairs: (json['pairs'] as List<dynamic>?)
              ?.map((e) => CurrencyPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CurrencyPair>[],
    );

Map<String, dynamic> _$CurrencyPairStateToJson(CurrencyPairState instance) =>
    <String, dynamic>{
      'status': _$PostStatusEnumMap[instance.status]!,
      'pairs': instance.pairs,
    };

const _$PostStatusEnumMap = {
  PostStatus.initial: 'initial',
  PostStatus.success: 'success',
  PostStatus.failure: 'failure',
};
