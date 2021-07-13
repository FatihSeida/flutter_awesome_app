import 'dart:async';

import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/repositories/photo_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc(this.photoRepository) : super(PhotoInitial());

  final PhotoRepository photoRepository;

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is FetchPhoto) {
      yield* mapFetchPhotoToState();
    }
  }

  Stream<PhotoState> mapFetchPhotoToState() async* {
    yield PhotoLoading();
    try {
      final agendaData = await photoRepository.fetchPhoto();
      yield PhotoLoaded(agendaData);
    } catch (_) {
      yield PhotoError();
    }
    try {} catch (e) {}
  }
}
