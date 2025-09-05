import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_employee_state.dart';

class CreateEmployeeCubit extends Cubit<CreateEmployeeState> {
  FirebaseFirestoreService _service;
  CreateEmployeeCubit(this._service) : super(CreateEmployeeInitial());

  void createEmployee({required String name, required String email, required String embeddData}) async {
    try {
      emit(CreateEmployeeLoading());

      await _service.createData(name: name, email: email, faceChar: embeddData);

      emit(CreateEmployeeSuccess(true));
    } catch (e) {
      emit(CreateEmployeeError(e.toString()));
    }
  }
}
