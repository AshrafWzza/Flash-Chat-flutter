part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {
  bool isLoading;
  RegisterLoading({required this.isLoading});
}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final Exception exception;
  RegisterFailure({required this.exception});
}

class LoginLoading extends AuthState {
  bool isLoading;
  LoginLoading({required this.isLoading});
}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final Exception exception;
  LoginFailure({required this.exception});
}
