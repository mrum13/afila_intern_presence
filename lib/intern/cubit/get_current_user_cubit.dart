import 'package:afila_intern_presence/intern/models/user_model.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_current_user_state.dart';

class GetCurrentUserCubit extends Cubit<GetCurrentUserState> {
  final FirebaseFirestoreService _service;
  GetCurrentUserCubit(this._service) : super(GetCurrentUserInitial());

  void getData({required String docId}) async {
    try {
      DMethod.log(docId, prefix: "docId");
      emit(GetCurrentUserLoading());

      var result = await _service.getCurrentUser(docId);

      emit(GetCurrentUserSuccess(result));
    } catch (e) {
      emit(GetCurrentUserFailed(e.toString()));
    }
  }
}
