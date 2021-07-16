import 'package:awesome_app/enums/layout_mode.dart';
import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostState', () {
    const mockAlbum = Album(page: 1, perPage: 20, photos: [
      Photo(
          id: 0,
          width: 0,
          height: 0,
          url: '',
          photographer: '',
          photographerUrl: '',
          photographerId: 0,
          avgColor: '',
          src: Src(
              original: '',
              large2X: '',
              large: '',
              medium: '',
              small: '',
              portrait: '',
              landscape: '',
              tiny: ''),
          liked: false)
    ]);

    const mockPhoto = [
      Photo(
          id: 0,
          width: 0,
          height: 0,
          url: '',
          photographer: '',
          photographerUrl: '',
          photographerId: 0,
          avgColor: '',
          src: Src(
              original: '',
              large2X: '',
              large: '',
              medium: '',
              small: '',
              portrait: '',
              landscape: '',
              tiny: ''),
          liked: false),
    ];
    test('supports value comparison', () {
      expect(
        const PhotoState(
                connectionResultMessage: '',
                hasReachedMax: false,
                isListView: false,
                page: 1,
                photoStatus: PhotoStatus.loaded,
                photos: mockPhoto,
                album: mockAlbum)
            .toString(),
        const PhotoState(
          connectionResultMessage: '',
          hasReachedMax: false,
          isListView: false,
          page: 1,
          photoStatus: PhotoStatus.loaded,
          photos: mockPhoto,
          album: mockAlbum
        ).toString(),
      );
    });
  });
}
