// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Bitcoin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bitcoin _$BitcoinFromJson(Map<String, dynamic> json) {
  return Bitcoin((json['price'] as num)?.toDouble(), json['type'] as String);
}

Map<String, dynamic> _$BitcoinToJson(Bitcoin instance) =>
    <String, dynamic>{'price': instance.price, 'type': instance.type};
