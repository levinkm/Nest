// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_sync_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SmsSyncEvent {
  int get daysBack => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int daysBack) syncSms,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int daysBack)? syncSms,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int daysBack)? syncSms,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncSms value) syncSms,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncSms value)? syncSms,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncSms value)? syncSms,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of SmsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmsSyncEventCopyWith<SmsSyncEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsSyncEventCopyWith<$Res> {
  factory $SmsSyncEventCopyWith(
    SmsSyncEvent value,
    $Res Function(SmsSyncEvent) then,
  ) = _$SmsSyncEventCopyWithImpl<$Res, SmsSyncEvent>;
  @useResult
  $Res call({int daysBack});
}

/// @nodoc
class _$SmsSyncEventCopyWithImpl<$Res, $Val extends SmsSyncEvent>
    implements $SmsSyncEventCopyWith<$Res> {
  _$SmsSyncEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daysBack = null}) {
    return _then(
      _value.copyWith(
            daysBack: null == daysBack
                ? _value.daysBack
                : daysBack // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncSmsImplCopyWith<$Res>
    implements $SmsSyncEventCopyWith<$Res> {
  factory _$$SyncSmsImplCopyWith(
    _$SyncSmsImpl value,
    $Res Function(_$SyncSmsImpl) then,
  ) = __$$SyncSmsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int daysBack});
}

/// @nodoc
class __$$SyncSmsImplCopyWithImpl<$Res>
    extends _$SmsSyncEventCopyWithImpl<$Res, _$SyncSmsImpl>
    implements _$$SyncSmsImplCopyWith<$Res> {
  __$$SyncSmsImplCopyWithImpl(
    _$SyncSmsImpl _value,
    $Res Function(_$SyncSmsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daysBack = null}) {
    return _then(
      _$SyncSmsImpl(
        daysBack: null == daysBack
            ? _value.daysBack
            : daysBack // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SyncSmsImpl implements SyncSms {
  const _$SyncSmsImpl({this.daysBack = 30});

  @override
  @JsonKey()
  final int daysBack;

  @override
  String toString() {
    return 'SmsSyncEvent.syncSms(daysBack: $daysBack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncSmsImpl &&
            (identical(other.daysBack, daysBack) ||
                other.daysBack == daysBack));
  }

  @override
  int get hashCode => Object.hash(runtimeType, daysBack);

  /// Create a copy of SmsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncSmsImplCopyWith<_$SyncSmsImpl> get copyWith =>
      __$$SyncSmsImplCopyWithImpl<_$SyncSmsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int daysBack) syncSms,
  }) {
    return syncSms(daysBack);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int daysBack)? syncSms,
  }) {
    return syncSms?.call(daysBack);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int daysBack)? syncSms,
    required TResult orElse(),
  }) {
    if (syncSms != null) {
      return syncSms(daysBack);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SyncSms value) syncSms,
  }) {
    return syncSms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SyncSms value)? syncSms,
  }) {
    return syncSms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SyncSms value)? syncSms,
    required TResult orElse(),
  }) {
    if (syncSms != null) {
      return syncSms(this);
    }
    return orElse();
  }
}

abstract class SyncSms implements SmsSyncEvent {
  const factory SyncSms({final int daysBack}) = _$SyncSmsImpl;

  @override
  int get daysBack;

  /// Create a copy of SmsSyncEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncSmsImplCopyWith<_$SyncSmsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SmsSyncState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() syncing,
    required TResult Function(int count) success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? syncing,
    TResult? Function(int count)? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? syncing,
    TResult Function(int count)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SmsSyncInitial value) initial,
    required TResult Function(SmsSyncing value) syncing,
    required TResult Function(SmsSyncSuccess value) success,
    required TResult Function(SmsSyncError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsSyncInitial value)? initial,
    TResult? Function(SmsSyncing value)? syncing,
    TResult? Function(SmsSyncSuccess value)? success,
    TResult? Function(SmsSyncError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsSyncInitial value)? initial,
    TResult Function(SmsSyncing value)? syncing,
    TResult Function(SmsSyncSuccess value)? success,
    TResult Function(SmsSyncError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsSyncStateCopyWith<$Res> {
  factory $SmsSyncStateCopyWith(
    SmsSyncState value,
    $Res Function(SmsSyncState) then,
  ) = _$SmsSyncStateCopyWithImpl<$Res, SmsSyncState>;
}

/// @nodoc
class _$SmsSyncStateCopyWithImpl<$Res, $Val extends SmsSyncState>
    implements $SmsSyncStateCopyWith<$Res> {
  _$SmsSyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SmsSyncInitialImplCopyWith<$Res> {
  factory _$$SmsSyncInitialImplCopyWith(
    _$SmsSyncInitialImpl value,
    $Res Function(_$SmsSyncInitialImpl) then,
  ) = __$$SmsSyncInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SmsSyncInitialImplCopyWithImpl<$Res>
    extends _$SmsSyncStateCopyWithImpl<$Res, _$SmsSyncInitialImpl>
    implements _$$SmsSyncInitialImplCopyWith<$Res> {
  __$$SmsSyncInitialImplCopyWithImpl(
    _$SmsSyncInitialImpl _value,
    $Res Function(_$SmsSyncInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SmsSyncInitialImpl implements SmsSyncInitial {
  const _$SmsSyncInitialImpl();

  @override
  String toString() {
    return 'SmsSyncState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SmsSyncInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() syncing,
    required TResult Function(int count) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? syncing,
    TResult? Function(int count)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? syncing,
    TResult Function(int count)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SmsSyncInitial value) initial,
    required TResult Function(SmsSyncing value) syncing,
    required TResult Function(SmsSyncSuccess value) success,
    required TResult Function(SmsSyncError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsSyncInitial value)? initial,
    TResult? Function(SmsSyncing value)? syncing,
    TResult? Function(SmsSyncSuccess value)? success,
    TResult? Function(SmsSyncError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsSyncInitial value)? initial,
    TResult Function(SmsSyncing value)? syncing,
    TResult Function(SmsSyncSuccess value)? success,
    TResult Function(SmsSyncError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SmsSyncInitial implements SmsSyncState {
  const factory SmsSyncInitial() = _$SmsSyncInitialImpl;
}

/// @nodoc
abstract class _$$SmsSyncingImplCopyWith<$Res> {
  factory _$$SmsSyncingImplCopyWith(
    _$SmsSyncingImpl value,
    $Res Function(_$SmsSyncingImpl) then,
  ) = __$$SmsSyncingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SmsSyncingImplCopyWithImpl<$Res>
    extends _$SmsSyncStateCopyWithImpl<$Res, _$SmsSyncingImpl>
    implements _$$SmsSyncingImplCopyWith<$Res> {
  __$$SmsSyncingImplCopyWithImpl(
    _$SmsSyncingImpl _value,
    $Res Function(_$SmsSyncingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SmsSyncingImpl implements SmsSyncing {
  const _$SmsSyncingImpl();

  @override
  String toString() {
    return 'SmsSyncState.syncing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SmsSyncingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() syncing,
    required TResult Function(int count) success,
    required TResult Function(String message) error,
  }) {
    return syncing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? syncing,
    TResult? Function(int count)? success,
    TResult? Function(String message)? error,
  }) {
    return syncing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? syncing,
    TResult Function(int count)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SmsSyncInitial value) initial,
    required TResult Function(SmsSyncing value) syncing,
    required TResult Function(SmsSyncSuccess value) success,
    required TResult Function(SmsSyncError value) error,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsSyncInitial value)? initial,
    TResult? Function(SmsSyncing value)? syncing,
    TResult? Function(SmsSyncSuccess value)? success,
    TResult? Function(SmsSyncError value)? error,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsSyncInitial value)? initial,
    TResult Function(SmsSyncing value)? syncing,
    TResult Function(SmsSyncSuccess value)? success,
    TResult Function(SmsSyncError value)? error,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class SmsSyncing implements SmsSyncState {
  const factory SmsSyncing() = _$SmsSyncingImpl;
}

/// @nodoc
abstract class _$$SmsSyncSuccessImplCopyWith<$Res> {
  factory _$$SmsSyncSuccessImplCopyWith(
    _$SmsSyncSuccessImpl value,
    $Res Function(_$SmsSyncSuccessImpl) then,
  ) = __$$SmsSyncSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int count});
}

/// @nodoc
class __$$SmsSyncSuccessImplCopyWithImpl<$Res>
    extends _$SmsSyncStateCopyWithImpl<$Res, _$SmsSyncSuccessImpl>
    implements _$$SmsSyncSuccessImplCopyWith<$Res> {
  __$$SmsSyncSuccessImplCopyWithImpl(
    _$SmsSyncSuccessImpl _value,
    $Res Function(_$SmsSyncSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? count = null}) {
    return _then(
      _$SmsSyncSuccessImpl(
        null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SmsSyncSuccessImpl implements SmsSyncSuccess {
  const _$SmsSyncSuccessImpl(this.count);

  @override
  final int count;

  @override
  String toString() {
    return 'SmsSyncState.success(count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsSyncSuccessImpl &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsSyncSuccessImplCopyWith<_$SmsSyncSuccessImpl> get copyWith =>
      __$$SmsSyncSuccessImplCopyWithImpl<_$SmsSyncSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() syncing,
    required TResult Function(int count) success,
    required TResult Function(String message) error,
  }) {
    return success(count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? syncing,
    TResult? Function(int count)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? syncing,
    TResult Function(int count)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SmsSyncInitial value) initial,
    required TResult Function(SmsSyncing value) syncing,
    required TResult Function(SmsSyncSuccess value) success,
    required TResult Function(SmsSyncError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsSyncInitial value)? initial,
    TResult? Function(SmsSyncing value)? syncing,
    TResult? Function(SmsSyncSuccess value)? success,
    TResult? Function(SmsSyncError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsSyncInitial value)? initial,
    TResult Function(SmsSyncing value)? syncing,
    TResult Function(SmsSyncSuccess value)? success,
    TResult Function(SmsSyncError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SmsSyncSuccess implements SmsSyncState {
  const factory SmsSyncSuccess(final int count) = _$SmsSyncSuccessImpl;

  int get count;

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmsSyncSuccessImplCopyWith<_$SmsSyncSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SmsSyncErrorImplCopyWith<$Res> {
  factory _$$SmsSyncErrorImplCopyWith(
    _$SmsSyncErrorImpl value,
    $Res Function(_$SmsSyncErrorImpl) then,
  ) = __$$SmsSyncErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SmsSyncErrorImplCopyWithImpl<$Res>
    extends _$SmsSyncStateCopyWithImpl<$Res, _$SmsSyncErrorImpl>
    implements _$$SmsSyncErrorImplCopyWith<$Res> {
  __$$SmsSyncErrorImplCopyWithImpl(
    _$SmsSyncErrorImpl _value,
    $Res Function(_$SmsSyncErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SmsSyncErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SmsSyncErrorImpl implements SmsSyncError {
  const _$SmsSyncErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SmsSyncState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsSyncErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsSyncErrorImplCopyWith<_$SmsSyncErrorImpl> get copyWith =>
      __$$SmsSyncErrorImplCopyWithImpl<_$SmsSyncErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() syncing,
    required TResult Function(int count) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? syncing,
    TResult? Function(int count)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? syncing,
    TResult Function(int count)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SmsSyncInitial value) initial,
    required TResult Function(SmsSyncing value) syncing,
    required TResult Function(SmsSyncSuccess value) success,
    required TResult Function(SmsSyncError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SmsSyncInitial value)? initial,
    TResult? Function(SmsSyncing value)? syncing,
    TResult? Function(SmsSyncSuccess value)? success,
    TResult? Function(SmsSyncError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SmsSyncInitial value)? initial,
    TResult Function(SmsSyncing value)? syncing,
    TResult Function(SmsSyncSuccess value)? success,
    TResult Function(SmsSyncError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SmsSyncError implements SmsSyncState {
  const factory SmsSyncError(final String message) = _$SmsSyncErrorImpl;

  String get message;

  /// Create a copy of SmsSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmsSyncErrorImplCopyWith<_$SmsSyncErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
