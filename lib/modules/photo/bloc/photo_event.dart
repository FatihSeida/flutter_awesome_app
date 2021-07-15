part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class FetchPhoto extends PhotoEvent {}

class ToggleLayoutMode extends PhotoEvent {
  final LayoutMode layoutMode;

  ToggleLayoutMode(this.layoutMode);

  @override
  List<Object> get props => [layoutMode];
}

class LoadMorePhoto extends PhotoEvent {}
