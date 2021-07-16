part of 'photo_bloc.dart';

enum PhotoStatus { loading, loaded, noConnection, error }

class PhotoState extends Equatable {
  final Album album;
  final List<Photo> photos;
  final bool isListView;
  final PhotoStatus photoStatus;
  final bool hasReachedMax;
  final int page;
  final String connectionResultMessage;

  const PhotoState({
    this.photos = const <Photo>[],
    this.photoStatus = PhotoStatus.loading,
    this.album = const Album(page: 0, perPage: 0, photos: []),
    this.isListView = true,
    this.hasReachedMax = false,
    this.page = 0,
    this.connectionResultMessage = '',
  });

  


  @override
  List<Object> get props => [
        album,
        isListView,
        photoStatus,
        hasReachedMax,
        page,
        connectionResultMessage,
        photos,
      ];

  // Future<LayoutMode> isListViews() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final isListViews = prefs.getString('isListView');
  //   final mode = json.decode(isListViews!);
  //   return mode;
  // }

  PhotoState copyWith({
    Album? album,
    List<Photo>? photos,
    bool? isListView,
    PhotoStatus? photoStatus,
    bool? hasReachedMax,
    int? page,
    String? connectionResultMessage,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      album: album ?? this.album,
      isListView: isListView ?? this.isListView,
      photoStatus: photoStatus ?? this.photoStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      connectionResultMessage:
          connectionResultMessage ?? this.connectionResultMessage,
    );
  }

  factory PhotoState.initial() {
    return PhotoState(
      photos: [],
      album: Album(page: 1, perPage: 20, photos: []),
      photoStatus: PhotoStatus.loading,
      hasReachedMax: false,
      page: 0,
      connectionResultMessage: '',
    );
  }
}
