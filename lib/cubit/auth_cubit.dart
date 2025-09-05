import 'package:afila_intern_presence/services/firebase_auth_service.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _service;
  AuthCubit(this._service) : super(AuthInitial());

  void signIn({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      var result = await _service.signInUser(email, password);

      DMethod.log(result.toString(), prefix: "SIGN IN User");

      emit(AuthSuccess(result.user!.email!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

    void signOut() async {
    try {
      emit(AuthLoading());

      await _service.signOut();

      emit(SingOut(true));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
