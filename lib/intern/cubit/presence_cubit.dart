import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'presence_state.dart';

class PresenceCubit extends Cubit<PresenceState> {
  FirebaseFirestoreService _service;
  PresenceCubit(this._service) : super(PresenceInitial());

    void presence({
      required String presenceStatement, 
      required String status, 
      required String checkInTime, 
      required String checkOutTime
    }) async {
    try {
      emit(PresenceLoading());

      await _service.presence(presenceStatement: presenceStatement, status: status, checkInTime: checkInTime, checkOutTime: checkOutTime);

      emit(PresenceSuccess(true));
    } catch (e) {
      emit(PresenceFailed(e.toString()));
    }
  }

  void deviceChecking(){
    emit(DeviceChecking());
    Future.delayed(Duration(seconds: 2)).then((value) => emit(PresenceInitial()),);
  }
}
