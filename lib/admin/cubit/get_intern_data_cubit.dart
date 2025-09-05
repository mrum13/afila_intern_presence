import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/services/firebase_auth_service.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:d_method/d_method.dart';
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

      DMethod.log(result.toString(), prefix: "Get Data Intern");

      emit(GetInternDataSuccess(result));
    } catch (e) {
      emit(GetInternDataError(e.toString()));
    }
  }
}
