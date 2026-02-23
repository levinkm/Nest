// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FilterPreset _$FilterPresetFromJson(Map<String, dynamic> json) {
  return _FilterPreset.fromJson(json);
}

/// @nodoc
mixin _$FilterPreset {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;
  List<String> get paymentMethods => throw _privateConstructorUsedError;
  String? get dateRangeStart => throw _privateConstructorUsedError;
  String? get dateRangeEnd => throw _privateConstructorUsedError;
  double? get minAmount => throw _privateConstructorUsedError;
  double? get maxAmount => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;

  /// Serializes this FilterPreset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterPresetCopyWith<FilterPreset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterPresetCopyWith<$Res> {
  factory $FilterPresetCopyWith(
    FilterPreset value,
    $Res Function(FilterPreset) then,
  ) = _$FilterPresetCopyWithImpl<$Res, FilterPreset>;
  @useResult
  $Res call({
    String id,
    String name,
    List<String> categories,
    List<String> types,
    List<String> paymentMethods,
    String? dateRangeStart,
    String? dateRangeEnd,
    double? minAmount,
    double? maxAmount,
    String sortBy,
  });
}

/// @nodoc
class _$FilterPresetCopyWithImpl<$Res, $Val extends FilterPreset>
    implements $FilterPresetCopyWith<$Res> {
  _$FilterPresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categories = null,
    Object? types = null,
    Object? paymentMethods = null,
    Object? dateRangeStart = freezed,
    Object? dateRangeEnd = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? sortBy = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            types: null == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            paymentMethods: null == paymentMethods
                ? _value.paymentMethods
                : paymentMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            dateRangeStart: freezed == dateRangeStart
                ? _value.dateRangeStart
                : dateRangeStart // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateRangeEnd: freezed == dateRangeEnd
                ? _value.dateRangeEnd
                : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                      as String?,
            minAmount: freezed == minAmount
                ? _value.minAmount
                : minAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxAmount: freezed == maxAmount
                ? _value.maxAmount
                : maxAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            sortBy: null == sortBy
                ? _value.sortBy
                : sortBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FilterPresetImplCopyWith<$Res>
    implements $FilterPresetCopyWith<$Res> {
  factory _$$FilterPresetImplCopyWith(
    _$FilterPresetImpl value,
    $Res Function(_$FilterPresetImpl) then,
  ) = __$$FilterPresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<String> categories,
    List<String> types,
    List<String> paymentMethods,
    String? dateRangeStart,
    String? dateRangeEnd,
    double? minAmount,
    double? maxAmount,
    String sortBy,
  });
}

/// @nodoc
class __$$FilterPresetImplCopyWithImpl<$Res>
    extends _$FilterPresetCopyWithImpl<$Res, _$FilterPresetImpl>
    implements _$$FilterPresetImplCopyWith<$Res> {
  __$$FilterPresetImplCopyWithImpl(
    _$FilterPresetImpl _value,
    $Res Function(_$FilterPresetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? categories = null,
    Object? types = null,
    Object? paymentMethods = null,
    Object? dateRangeStart = freezed,
    Object? dateRangeEnd = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? sortBy = null,
  }) {
    return _then(
      _$FilterPresetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        types: null == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        paymentMethods: null == paymentMethods
            ? _value._paymentMethods
            : paymentMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        dateRangeStart: freezed == dateRangeStart
            ? _value.dateRangeStart
            : dateRangeStart // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateRangeEnd: freezed == dateRangeEnd
            ? _value.dateRangeEnd
            : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                  as String?,
        minAmount: freezed == minAmount
            ? _value.minAmount
            : minAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxAmount: freezed == maxAmount
            ? _value.maxAmount
            : maxAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterPresetImpl implements _FilterPreset {
  const _$FilterPresetImpl({
    required this.id,
    required this.name,
    required final List<String> categories,
    required final List<String> types,
    required final List<String> paymentMethods,
    this.dateRangeStart,
    this.dateRangeEnd,
    this.minAmount,
    this.maxAmount,
    this.sortBy = 'date_desc',
  }) : _categories = categories,
       _types = types,
       _paymentMethods = paymentMethods;

  factory _$FilterPresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterPresetImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  final List<String> _paymentMethods;
  @override
  List<String> get paymentMethods {
    if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethods);
  }

  @override
  final String? dateRangeStart;
  @override
  final String? dateRangeEnd;
  @override
  final double? minAmount;
  @override
  final double? maxAmount;
  @override
  @JsonKey()
  final String sortBy;

  @override
  String toString() {
    return 'FilterPreset(id: $id, name: $name, categories: $categories, types: $types, paymentMethods: $paymentMethods, dateRangeStart: $dateRangeStart, dateRangeEnd: $dateRangeEnd, minAmount: $minAmount, maxAmount: $maxAmount, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterPresetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            const DeepCollectionEquality().equals(
              other._paymentMethods,
              _paymentMethods,
            ) &&
            (identical(other.dateRangeStart, dateRangeStart) ||
                other.dateRangeStart == dateRangeStart) &&
            (identical(other.dateRangeEnd, dateRangeEnd) ||
                other.dateRangeEnd == dateRangeEnd) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_types),
    const DeepCollectionEquality().hash(_paymentMethods),
    dateRangeStart,
    dateRangeEnd,
    minAmount,
    maxAmount,
    sortBy,
  );

  /// Create a copy of FilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterPresetImplCopyWith<_$FilterPresetImpl> get copyWith =>
      __$$FilterPresetImplCopyWithImpl<_$FilterPresetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterPresetImplToJson(this);
  }
}

abstract class _FilterPreset implements FilterPreset {
  const factory _FilterPreset({
    required final String id,
    required final String name,
    required final List<String> categories,
    required final List<String> types,
    required final List<String> paymentMethods,
    final String? dateRangeStart,
    final String? dateRangeEnd,
    final double? minAmount,
    final double? maxAmount,
    final String sortBy,
  }) = _$FilterPresetImpl;

  factory _FilterPreset.fromJson(Map<String, dynamic> json) =
      _$FilterPresetImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get categories;
  @override
  List<String> get types;
  @override
  List<String> get paymentMethods;
  @override
  String? get dateRangeStart;
  @override
  String? get dateRangeEnd;
  @override
  double? get minAmount;
  @override
  double? get maxAmount;
  @override
  String get sortBy;

  /// Create a copy of FilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterPresetImplCopyWith<_$FilterPresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
