import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';

class PhotoOpenBuilder extends StatelessWidget {
  const PhotoOpenBuilder({required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.red,
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '${photo.src.small}',
                fit: BoxFit.cover,
              ),
              title: Text('Flexible Title'),
              centerTitle: true,
            ),
            leading: InkWell(
              onTap: Navigator.of(context).pop,
              child: Icon(Icons.arrow_back),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              Center(child: Text('${photo.photographer}'))
            ],
          )),
        ],
      ),
    );
  }
}
