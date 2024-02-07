import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CategoryLoading extends CategoryState {
  @override
  bool get stringify => true;
}

class CategoryLoaded extends CategoryState {
  @override
  bool get stringify => true;
}

class LoadCategoryFailed extends CategoryState {
  final String message;

  LoadCategoryFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}
