import 'package:equatable/equatable.dart';
import 'package:selleri/models/user.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class AuthLoading extends AuthState {
  @override
  bool get stringify => true;
}

class UnAuthenticated extends AuthState {
  @override
  bool get stringify => true;
}

class Authenticated extends AuthState {
  final User user;
  final String token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object> get props => [user];

  @override
  bool get stringify => true;
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
