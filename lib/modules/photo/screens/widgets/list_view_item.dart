import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({required this.photo, required this.openContainer});

  final Photo photo;
  final Function()? openContainer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openContainer,
      child: Row(
        children: <Widget>[
          Image.network(
            '${photo.src.small}',
            height: 200,
            fit: BoxFit.fitHeight,
          ),
          Column(
            children: <Widget>[
              Text('Photographer : ${photo.photographer}'),
            ],
          )
        ],
      ),
    );
  }
}
