part of 'photo_bloc.dart';

enum PhotoStatus { initial, loading, loaded, error }

class PhotoState extends Equatable {
  final List<Photo> photos;
  final LayoutMode layoutMode;
  final PhotoStatus photoStatus;
  final bool hasReachedMax;
  final int page;

  PhotoState({
    required this.photoStatus,
    required this.photos,
    required this.layoutMode,
    required this.hasReachedMax,
    required this.page,
  });

  @override
  List<Object> get props =>
      [photos, layoutMode, photoStatus, layoutMode, hasReachedMax, page];

  PhotoState copyWith({
    List<Photo>? photos,
    LayoutMode? layoutMode,
    PhotoStatus? photoStatus,
    bool? hasReachedMax,
    int? page,
  }) {
    return PhotoState(
        photos: photos ?? this.photos,
        layoutMode: layoutMode ?? this.layoutMode,
        photoStatus: photoStatus ?? this.photoStatus,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page);
  }

  factory PhotoState.initial() {
    return PhotoState(
      photos: [
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
          liked: false,
        ),
      ],
      layoutMode: LayoutMode.listview,
      photoStatus: PhotoStatus.initial,
      hasReachedMax: false,
      page: 0,
    );
  }
}
