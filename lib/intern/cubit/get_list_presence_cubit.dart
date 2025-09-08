import 'package:afila_intern_presence/intern/models/presence_model.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_list_presence_state.dart';

class GetListPresenceCubit extends Cubit<GetListPresenceState> {
 final  FirebaseFirestoreService _service;
  GetListPresenceCubit(this._service) : super(GetListPresenceInitial());

    void getData({bool isAdmin = false}) async {
    try {
      emit(GetListPresenceLoading());

      var result = await _service.getHistoryPresence(isAdmin: isAdmin);

      emit(GetListPresenceSuccess(result));
    } catch (e) {
      emit(GetListPresenceFailed(e.toString()));
    }
  }
}
