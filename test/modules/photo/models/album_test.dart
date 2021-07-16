import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post', () {
    const mockSrc = Src(
        original: '',
        large2X: '',
        large: '',
        medium: '',
        small: '',
        portrait: '',
        landscape: '',
        tiny: '');
    const mockPhoto = Photo(
        id: 0,
        width: 0,
        height: 0,
        url: '',
        photographer: '',
        photographerUrl: '',
        photographerId: 0,
        avgColor: '',
        src: mockSrc,
        liked: false);
    
    test('supports value comparison', () {
      expect(
        const Album(page: 1, perPage: 20, photos: [mockPhoto]),
        const Album(page: 1, perPage: 20, photos: [mockPhoto]),
      );
    });
  });
}
