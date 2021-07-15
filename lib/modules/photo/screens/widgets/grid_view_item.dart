import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  const GridViewItem({required this.photo, required this.openContainer});

  final Photo photo;
  final Function()? openContainer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.network(
          '${photo.src.small}',
          height: 200,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}
