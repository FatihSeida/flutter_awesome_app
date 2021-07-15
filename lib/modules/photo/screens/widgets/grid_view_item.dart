import 'package:awesome_app/modules/photo/models/album.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GridViewItem extends StatelessWidget {
  const GridViewItem({required this.photo, required this.openContainer});

  final Photo photo;
  final Function()? openContainer;

 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            '${photo.src.medium}',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.14,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/images/placeholder.png",
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.14,
              );
            },
          ),
          Text(
            'By : ${photo.photographer}',
            style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.caption,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: InkWell(
              onTap: () {
                launch(photo.url);
              },
              child: Text('${photo.url}',
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.blueAccent),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
