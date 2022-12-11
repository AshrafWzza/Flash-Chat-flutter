import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  bool? isLoading;
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
}
