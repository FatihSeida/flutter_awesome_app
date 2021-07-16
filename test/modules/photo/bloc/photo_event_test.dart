

import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostEvent', () {
    group('PostFetched', () {
      test('supports value comparison', () {
        expect(FetchPhoto(), FetchPhoto());
      });
    });
    group('LoadMore', () {
      test('supports value comparison', () {
        expect(LoadMorePhoto(), LoadMorePhoto());
      });
    });
    group('Toggle Grid', () {
      test('supports value comparison', () {
        expect(ToggleLayoutMode(false), ToggleLayoutMode(false));
      });
    });
  });
}
