import 'package:afila_intern_presence/admin/models/office_data_model.dart';
import 'package:afila_intern_presence/services/firebase_firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'office_data_state.dart';

class OfficeDataCubit extends Cubit<OfficeDataState> {
  final FirebaseFirestoreService _service;
  OfficeDataCubit(this._service) : super(OfficeDataInitial());

  void getData() async {
    try {
      emit(OfficeDataLoading());

      var result = await _service.getOfficeData();

      emit(GetOfficeDataSuccess(result));
    } catch (e) {
      emit(OfficeDataFailed(e.toString()));
    }
  }

  void setData({required String lat, required String long}) async {
    try {
      emit(OfficeDataLoading());

      var result = await _service.saveOrUpdateOfficeData(lat: lat, long: long);

      emit(SetOfficeDataSuccess(result));
    } catch (e) {
      emit(OfficeDataFailed(e.toString()));
    }
  }
}
