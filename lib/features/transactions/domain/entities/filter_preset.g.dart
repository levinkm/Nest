// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterPresetImpl _$$FilterPresetImplFromJson(Map<String, dynamic> json) =>
    _$FilterPresetImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dateRangeStart: json['dateRangeStart'] as String?,
      dateRangeEnd: json['dateRangeEnd'] as String?,
      minAmount: (json['minAmount'] as num?)?.toDouble(),
      maxAmount: (json['maxAmount'] as num?)?.toDouble(),
      sortBy: json['sortBy'] as String? ?? 'date_desc',
    );

Map<String, dynamic> _$$FilterPresetImplToJson(_$FilterPresetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categories': instance.categories,
      'types': instance.types,
      'paymentMethods': instance.paymentMethods,
      'dateRangeStart': instance.dateRangeStart,
      'dateRangeEnd': instance.dateRangeEnd,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'sortBy': instance.sortBy,
    };
