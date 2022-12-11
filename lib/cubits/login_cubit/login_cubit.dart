import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool? isLoading;
  Future<void> loginUser(
      {required String email, required String password}) async {
    isLoading = true;
    emit(LoginLoading(isLoading: isLoading!));
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      emit(LoginSuccess());
    } on Exception catch (e) {
      isLoading = false;
      emit(LoginFailure(exception: e));
    }
  }
}
