import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'dart:html' as html;

const tileSize = 200.0;

class PortfolioTile extends StatelessWidget {
  // a square tile with a title and background image to display one of my projects
  const PortfolioTile({
    Key? key,
    required this.title,
    required this.image,
    required this.url,
  }) : super(key: key);

  final String url;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              html.window.open(url, "testNAME");
            },
            child: Container(
                color: Colors.grey[800],
                height: tileSize,
                width: tileSize,
                child: Stack(
                  children: [
                    SizedBox(
                        height: tileSize,
                        width: tileSize,
                        child: FittedBox(
                            clipBehavior: Clip.hardEdge,
                            fit: BoxFit.cover,
                            child: Image.network(image))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DecoratedBox(
                          //transparent black background
                          decoration: BoxDecoration(color: Colors.black54),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      );
    });
  }
}
