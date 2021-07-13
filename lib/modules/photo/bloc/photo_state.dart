part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final Album album;

  PhotoLoaded(this.album);

  @override
  List<Object> get props => [album];
}

class PhotoError extends PhotoState {}
