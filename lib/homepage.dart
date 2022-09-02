import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'portfolio_tile.dart';

class HomePage extends StatefulWidget {
  int _counter = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: extractItchData(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 1),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      //alignment: WrapAlignment.center,
                      children: (snapshot.hasData)
                          ? snapshot.data as List<Widget>
                          : [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            ]),
                ),
              ],
            ),
          );
        });
  }
}

Future<List<PortfolioTile>> extractItchData() async {
//Getting the response from the targeted url

  final functionURL =
      "https://us-central1-johannes-nicholas.cloudfunctions.net/getData?url=";

  final response = await http.Client()
      .get(Uri.parse(functionURL + 'https://johannesnicholas.itch.io/'));
  //Status Code 200 means response has been received successfully
  if (response.statusCode == 200) {
    //Getting the html document from the response
    var document = parser.parse(response.body);
    try {
      var gameCells = document.getElementsByClassName('game_cell');

      //Converting the extracted titles into string and returning a list of Strings
      return gameCells.map((gameCell) {
        var title = gameCell.children[1].children[0].children[0].text.trim();
        var imageUrl =
            "https://us-central1-johannes-nicholas.cloudfunctions.net/getImage?url=" +
                Uri.encodeComponent(gameCell
                        .getElementsByTagName("img")[0]
                        .attributes["data-lazy_src"] ??
                    "https://avatars.githubusercontent.com/u/45587025");

        var url = gameCell.getElementsByTagName("a")[0].attributes["href"];

        return PortfolioTile(
          title: title,
          image: imageUrl,
          url: url ?? "https://johannesnicholas.itch.io/",
        );
      }).toList();
    } catch (e) {
      return [];
    }
  } else {
    return [];
  }
}
