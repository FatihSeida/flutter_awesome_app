part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class FetchPhoto extends PhotoEvent {}

class ToggleLayoutMode extends PhotoEvent {
  final bool isListView;

  ToggleLayoutMode(this.isListView);

  @override
  List<Object> get props => [isListView];
}

class LoadMorePhoto extends PhotoEvent {}
