import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/usecases/sync_sms_transactions.dart';

part 'sms_sync_bloc.freezed.dart';

@freezed
class SmsSyncEvent with _$SmsSyncEvent {
  const factory SmsSyncEvent.syncSms({@Default(30) int daysBack}) = SyncSms;
}

@freezed
class SmsSyncState with _$SmsSyncState {
  const factory SmsSyncState.initial() = SmsSyncInitial;
  const factory SmsSyncState.syncing() = SmsSyncing;
  const factory SmsSyncState.success(int count) = SmsSyncSuccess;
  const factory SmsSyncState.error(String message) = SmsSyncError;
}

class SmsSyncBloc extends Bloc<SmsSyncEvent, SmsSyncState> {
  final SyncSmsTransactionsUseCase syncUseCase;

  SmsSyncBloc(this.syncUseCase) : super(const SmsSyncState.initial()) {
    on<SyncSms>(_onSyncSms);
  }

  Future<void> _onSyncSms(SyncSms event, Emitter<SmsSyncState> emit) async {
    emit(const SmsSyncState.syncing());
    try {
      final count = await syncUseCase.execute(daysBack: event.daysBack);
      emit(SmsSyncState.success(count));
    } catch (e) {
      emit(SmsSyncState.error(e.toString()));
    }
  }
}
