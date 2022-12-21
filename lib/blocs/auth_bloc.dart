import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      bool? isLoading;
      if (event is LoginEvent) {
        isLoading = true;
        emit(LoginLoading(isLoading: isLoading));
        try {
          final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);
          isLoading = false;
          emit(LoginSuccess());
        } on Exception catch (e) {
          isLoading = false;
          emit(LoginFailure(exception: e));
        }
      }
      if (event is RegisterEvent) {
        isLoading = true;
        emit(RegisterLoading(isLoading: isLoading));
        try {
          final user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: event.email, password: event.password);
          isLoading = false;
          emit(RegisterSuccess());
        } on Exception catch (e) {
          isLoading = false;
          emit(RegisterFailure(exception: e));
        }
      }
    });
  }
  // * use SimpleBlocObserver
  /*@override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print('****************************************************$transition');
  }*/
}
