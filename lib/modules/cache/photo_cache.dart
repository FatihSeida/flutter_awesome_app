class PhotoCache {
  final _cache = <String, List<dynamic>>{};

  List<dynamic>? get() => _cache['photoData'];

  void set(List<dynamic> result) => _cache['photoData'] = result;

  bool contains() => _cache.containsKey('photoData');

  void remove() => _cache.remove('photoData');

  void removeAll() => _cache.clear();
}
