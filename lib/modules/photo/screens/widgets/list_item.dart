import 'package:animations/animations.dart';
import 'package:awesome_app/enums/layout_mode.dart';
import 'package:awesome_app/modules/photo/bloc/photo_bloc.dart';
import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:awesome_app/modules/photo/screens/widgets/photo_open_builder.dart';
import 'package:flutter/material.dart';

import 'bottom_loader.dart';
import 'grid_view_item.dart';
import 'list_view_item.dart';

class ListItem extends StatelessWidget {
  const ListItem(this.state, this.photos);

  final PhotoState state;
  final List<Photo> photos;


  @override
  Widget build(BuildContext context) {
    return state.isListView == true
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index >= photos.length
                    ? BottomLoader()
                    : OpenContainer<bool>(
                        closedBuilder: (context, openContainer) => ListViewItem(
                            photo: photos[index], openContainer: openContainer),
                        openBuilder: (context, openContainer) =>
                            PhotoOpenBuilder(photo: photos[index]));
              },
              childCount:
                  state.hasReachedMax ? photos.length : photos.length + 1,
            ),
          )
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index >= photos.length
                    ? BottomLoader()
                    : OpenContainer<bool>(
                        closedBuilder: (context, openContainer) => GridViewItem(
                            photo: photos[index], openContainer: openContainer),
                        openBuilder: (context, openContainer) =>
                            PhotoOpenBuilder(photo: photos[index]),
                      );
              },
              childCount:
                  state.hasReachedMax ? photos.length : photos.length + 1,
            ),
          );
  }
}
