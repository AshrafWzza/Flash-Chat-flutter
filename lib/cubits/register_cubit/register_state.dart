part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {
  bool isLoading;
  RegisterLoading({required this.isLoading});
}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final Exception exception;
  RegisterFailure({required this.exception});
}
