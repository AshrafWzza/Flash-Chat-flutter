import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
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

  Future<void> registerUser(
      {required String email, required String password}) async {
    isLoading = true;
    emit(RegisterLoading(isLoading: isLoading!));
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      emit(RegisterSuccess());
    } on Exception catch (e) {
      isLoading = false;
      emit(RegisterFailure(exception: e));
    }
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print('****************************************************$change');
  }
}
