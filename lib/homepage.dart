import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

const tileSize = 200.0;

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
                          : [CircularProgressIndicator()]),
                ),
              ],
            ),
          );
        });
  }
}

class PortfolioTile extends StatelessWidget {
  // a square tile with a title and background image to display one of my projects
  const PortfolioTile({
    Key? key,
    required this.title,
    required this.image,
  }) : super(key: key);

  final title;
  final image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
            color: Colors.orange,
            height: tileSize,
            width: tileSize,
            child: Center(child: Text(title))),
      );
    });
  }
}

Future<List<PortfolioTile>> extractItchData() async {
//Getting the response from the targeted url
  final response =
      await http.Client().get(Uri.parse('https://johannesnicholas.itch.io/'));
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
            gameCell.getElementsByTagName("img")[0].attributes["data-lazy_src"];

        return PortfolioTile(
          title: title,
          image: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  } else {
    return [];
  }
}
