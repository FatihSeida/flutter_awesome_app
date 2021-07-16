import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/screens/home_page.dart';
import 'package:awesome_app/modules/photo/screens/widgets/bottom_loader.dart';
import 'package:awesome_app/modules/photo/screens/widgets/list_view_item.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakePhotoState extends Fake implements PhotoState {}

class FakePhotoEvent extends Fake implements PhotoEvent {}

class MockPhotoBloc extends MockBloc<PhotoEvent, PhotoState>
    implements PhotoBloc {}

extension on WidgetTester {
  Future<void> pumpPhotosList(PhotoBloc photoBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: photoBloc,
          child: MyHomePage(),
        ),
      ),
    );
  }
}

void main() {
  final mockPhotos = List.generate(
    3,
    (i) => Photo(
      avgColor: '',
      height: 0,
      id: 0,
      liked: false,
      photographer: '',
      photographerId: 0,
      photographerUrl: '',
      src: Src(
          original: '',
          large2X: 'large2X',
          large: 'large',
          medium: 'medium',
          small: 'small',
          portrait: 'portrait',
          landscape: 'landscape',
          tiny: 'tiny'),
      url: '',
      width: 0,
    ),
  );

  late PhotoBloc photoBloc;

  setUpAll(() {
    registerFallbackValue<PhotoState>(FakePhotoState());
    registerFallbackValue<PhotoEvent>(FakePhotoEvent());
  });

  setUp(() {
    photoBloc = MockPhotoBloc();
  });

  group('PhotosList', () {
    testWidgets(
        'renders CircularProgressIndicator '
        'when photo photoStatus is initial', (tester) async {
      when(() => photoBloc.state).thenReturn(const PhotoState());
      await tester.pumpPhotosList(photoBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders no photos text '
        'when photo photoStatus is success but with 0 photos', (tester) async {
      when(() => photoBloc.state).thenReturn(const PhotoState(
        photoStatus: PhotoStatus.loaded,
        photos: [],
        hasReachedMax: true,
      ));
      await tester.pumpPhotosList(photoBloc);
      expect(
          find.byWidget(SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(),
                Text('No Photo'),
              ],
            ),
          )),
          findsOneWidget);
    });

    testWidgets(
        'renders 3 photos and a bottom loader when photo max is not reached yet',
        (tester) async {
      when(() => photoBloc.state).thenReturn(PhotoState(
        photoStatus: PhotoStatus.loaded,
        photos: mockPhotos,
      ));
      await tester.pumpPhotosList(photoBloc);
      expect(find.byType(ListViewItem), findsNWidgets(3));
      expect(find.byType(BottomLoader), findsOneWidget);
    });

    testWidgets('does not render bottom loader when photo max is reached',
        (tester) async {
      when(() => photoBloc.state).thenReturn(PhotoState(
        photoStatus: PhotoStatus.loaded,
        photos: mockPhotos,
        hasReachedMax: true,
      ));
      await tester.pumpPhotosList(photoBloc);
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets('fetches more photos when scrolled to the bottom',
        (tester) async {
      when(() => photoBloc.state).thenReturn(
        PhotoState(
          photoStatus: PhotoStatus.loaded,
          photos: List.generate(
            10,
            (i) => Photo(
              avgColor: '',
              height: 0,
              id: 0,
              liked: false,
              photographer: '',
              photographerId: 0,
              photographerUrl: '',
              src: Src(
                  original: '',
                  large2X: 'large2X',
                  large: 'large',
                  medium: 'medium',
                  small: 'small',
                  portrait: 'portrait',
                  landscape: 'landscape',
                  tiny: 'tiny'),
              url: '',
              width: 0,
            ),
          ),
        ),
      );
      await tester.pumpPhotosList(photoBloc);
      await tester.drag(find.byType(ListViewItem), const Offset(0, -500));
      verify(() => photoBloc.add(LoadMorePhoto())).called(1);
    });
  });
}
