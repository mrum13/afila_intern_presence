import 'package:flutter_bloc/flutter_bloc.dart';


class NavbarCubit extends Cubit<int> {
  NavbarCubit() : super(0);

  void setIndexPage({required int index}) {
    emit(index);
  }
}
