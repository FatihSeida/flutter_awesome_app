import 'package:awesome_app/modules/photo/models/album.dart';

class PhotoCache {
  final _cache = <String, Album>{};

  Album? get() => _cache['AlbumData'];

  void set(Album result) => _cache['AlbumData'] = result;

  bool contains() => _cache.containsKey('AlbumData');

  void remove() => _cache.remove('AlbumData');

  void removeAll() => _cache.clear();
}
