import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_intern_data_state.dart';

class GetInternDataCubit extends Cubit<GetInternDataState> {
  final FirebaseFirestoreService _service;
  GetInternDataCubit(this._service) : super(GetInternDataInitial());

    void getData() async {
    try {
      emit(GetInternDataLoading());

      var result = await _service.getDataEmployee();

      emit(GetInternDataSuccess(result));
    } catch (e) {
      emit(GetInternDataError(e.toString()));
    }
  }
}
