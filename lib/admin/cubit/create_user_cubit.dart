import 'package:afila_intern_presence/services/firebase_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final FirebaseAuthService _service;
  CreateUserCubit(this._service)
      : super(CreateUserInitial());

  void createUser({required String email, required String password}) async {
    try {
      emit(CreateUserLoading());

      await _service.createUser(email, password);

      emit(CreateUserSuccess(true));
    } catch (e) {
      emit(CreateUserError(e.toString()));
    }
  }
}
