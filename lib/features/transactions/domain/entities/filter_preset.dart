import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_preset.freezed.dart';
part 'filter_preset.g.dart';

@freezed
class FilterPreset with _$FilterPreset {
  const factory FilterPreset({
    required String id,
    required String name,
    required List<String> categories,
    required List<String> types,
    required List<String> paymentMethods,
    String? dateRangeStart,
    String? dateRangeEnd,
    double? minAmount,
    double? maxAmount,
    @Default('date_desc') String sortBy,
  }) = _FilterPreset;

  factory FilterPreset.fromJson(Map<String, dynamic> json) =>
      _$FilterPresetFromJson(json);
}
