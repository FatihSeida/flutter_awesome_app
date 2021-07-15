import 'dart:async';

import 'package:awesome_app/enums/layout_mode.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/repositories/photo_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc(this.photoRepository) : super(PhotoState.initial());

  final PhotoRepository photoRepository;

  @override
  Stream<Transition<PhotoEvent, PhotoState>> transformEvents(
    Stream<PhotoEvent> events,
    Stream<Transition<PhotoEvent, PhotoState>> Function(
      PhotoEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 250))
        .switchMap(transitionFn);
  }

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is FetchPhoto) {
      yield* mapFetchPhotoToState();
    }

    if (event is ToggleLayoutMode) {
      yield* mapToggleLayoutModeToState(event);
    }

    if (event is LoadMorePhoto) {
      yield* mapLoadMorePhotoToState(state);
    }
  }

  Stream<PhotoState> mapFetchPhotoToState() async* {
    yield state.copyWith(photoStatus: PhotoStatus.loading);
    try {
      final albumData = await photoRepository.fetchPhoto();
      yield state.copyWith(
          photos: albumData.photos, photoStatus: PhotoStatus.loaded, page: albumData.page);
    } catch (e) {}
  }

  Stream<PhotoState> mapToggleLayoutModeToState(ToggleLayoutMode event) async* {
    print(event.layoutMode);
    yield state.copyWith(layoutMode: event.layoutMode);
  }

  Stream<PhotoState> mapLoadMorePhotoToState(PhotoState state) async* {
    try {
      if (state.photoStatus == PhotoStatus.loaded) {
        int page = state.page;
        ++page;
        final albumData = await photoRepository.fetchPhoto(page);
        yield state.copyWith(
          photoStatus: PhotoStatus.loaded,
          photos: List.of(state.photos)..addAll(albumData.photos),
          page: page,
          hasReachedMax: false,
        );
      }
    } catch (e) {}
  }
}
