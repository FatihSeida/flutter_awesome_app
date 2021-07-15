import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({required this.photo, required this.openContainer});

  final Photo photo;
  final Function()? openContainer;

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openContainer,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network(
              '${photo.src.medium}',
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.15,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/placeholder.png",
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.15,
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'By : ${photo.photographer}',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: InkWell(
                    onTap: () {
                      launch(photo.url);
                    },
                    child: Text('${photo.url}',
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.blueAccent),
                        )),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
