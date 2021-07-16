import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/repositories/photo_repository.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockRepository extends Mock implements PhotoRepository {}

class MockConnectivity extends Mock implements Connectivity {}

Uri fetchUrl([int page = 1]) {
  return Uri.https(
    'api.pexels.com',
    '/v1/curated?',
    <String, String>{'page': '$page', 'per_page': '20'},
  );
}

void main() {
  group('PhotoBloc', () {
    const mockSrc = Src(
        original: '',
        large2X: '',
        large: '',
        medium: '',
        small: '',
        portrait: '',
        landscape: '',
        tiny: '');
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
          src: mockSrc,
          liked: false)
    ];
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
    const extraMockPhotos = [
      Photo(
          id: 2,
          width: 2,
          height: 2,
          url: '',
          photographer: '',
          photographerUrl: '',
          photographerId: 2,
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
    PhotoState mockPhotoState = PhotoState(
      photoStatus: PhotoStatus.loading,
      photos: [],
      hasReachedMax: false,
      album: mockAlbum,
      connectionResultMessage: '',
      isListView: true,
      page: 0,
    );

    late MockRepository photoRepository;
    late http.Client httpClient;
    late MockConnectivity connectivity;

    setUpAll(() {
      registerFallbackValue(Uri());
      httpClient = MockClient();
      photoRepository = MockRepository();
      connectivity = MockConnectivity();
    });

    test('initial state is PhotoState()', () {
      expect(PhotoBloc(photoRepository).state.photoStatus, PhotoStatus.loading);
    });

    group('PhotoFetched', () {
      blocTest<PhotoBloc, PhotoState>(
        'emits nothing when posts has reached maximum amount',
        build: () => PhotoBloc(photoRepository),
        seed: () => PhotoState.initial(),
        act: (bloc) => bloc.add(FetchPhoto()),
        expect: () => <PhotoState>[],
      );

      blocTest<PhotoBloc, PhotoState>(
        'emits successful status when http fetches initial posts',
        build: () {
          
          // when(() => connectivity.checkConnectivity())
          //     .thenAnswer((invocation) async {
          //   return ConnectivityResult.mobile;
          // });
          when(() => photoRepository.fetchPhoto(any())).thenAnswer((_) async {
            return mockAlbum;
          });
          return PhotoBloc(photoRepository);
        },
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(FetchPhoto()),
        // expect: () =>
        //     // [isA<PhotoState>()],
        //     <PhotoState>[
        //   mockPhotoState.copyWith(album: mockAlbum,isListView: true,photoStatus: PhotoStatus.loading, hasReachedMax: false, page: 0, connectionResultMessage: '', photos: []),
        //   mockPhotoState.copyWith(
        //       photoStatus: PhotoStatus.loaded, photos: mockPhoto, page: 1),
        // ],
        verify: (_) {
          verify(() => photoRepository.fetchPhoto()).called(1);
        },
      );

      blocTest<PhotoBloc, PhotoState>(
        'emits failure status when http fetches posts and throw exception',
        build: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('', 403),
          );
          return PhotoBloc(photoRepository);
        },
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(FetchPhoto()),
        expect: () =>
            <PhotoState>[const PhotoState(photoStatus: PhotoStatus.error)],
        verify: (_) {
          verify(() => httpClient.get(fetchUrl(1))).called(1);
        },
      );

      blocTest<PhotoBloc, PhotoState>(
        'emits successful status and reaches max posts when '
        '0 additional posts are fetched',
        build: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('[]', 200),
          );
          return PhotoBloc(photoRepository);
        },
        seed: () => const PhotoState(
          photoStatus: PhotoStatus.loading,
          photos: mockPhoto,
        ),
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(LoadMorePhoto()),
        expect: () => const <PhotoState>[
          PhotoState(
            photoStatus: PhotoStatus.loaded,
            photos: mockPhoto,
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(fetchUrl(1))).called(1);
        },
      );

      blocTest<PhotoBloc, PhotoState>(
        'emits successful status and does not reach max posts'
        'when additional posts are fetched',
        build: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 2, "title": "post title", "body": "post body" }]',
              200,
            );
          });
          return PhotoBloc(photoRepository);
        },
        seed: () => const PhotoState(
          photoStatus: PhotoStatus.loading,
          photos: mockPhoto,
        ),
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(LoadMorePhoto()),
        expect: () => <PhotoState>[
          PhotoState(
            photoStatus: PhotoStatus.loaded,
            photos: [...mockPhoto, ...extraMockPhotos],
            hasReachedMax: false,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(fetchUrl(2))).called(1);
        },
      );
    });
  });
}
