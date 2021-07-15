import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoOpenBuilder extends StatelessWidget {
  const PhotoOpenBuilder({required this.photo});

  final Photo photo;

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.red,
            expandedHeight: 800,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '${photo.src.large}',
                fit: BoxFit.cover,
              ),
              title: InkWell(
                  onTap: () {
                    _launchURL(photo.url);
                  },
                  child: Row(
                    children: [
                      Text('${photo.photographer} | '),
                      Text('More'),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
              centerTitle: true,
              titlePadding: EdgeInsets.only(left: 50, bottom: 12),
            ),
            leading: InkWell(
              onTap: Navigator.of(context).pop,
              child: Icon(Icons.arrow_back),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 1,
              )
            ],
          )),
        ],
      ),
    );
  }
}
