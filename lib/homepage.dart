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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 8),
              child: Text("Socials"),
            ),
            Socials(),
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 8),
              child: Text("GitHub Repos"),
            ),
            FutureProjects(
              futureChildren: extractGitHubData(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 8),
              child: Text("Itch games"),
            ),
            FutureProjects(
              futureChildren: extractItchData(),
            ),
          ],
        ),
      ),
    );
  }
}

class Socials extends StatelessWidget {
  const Socials({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              //alignment: WrapAlignment.center,
              children: [
                ...[
                  const PortfolioTile(
                    title: "GitHub",
                    image:
                        "https://avatars.githubusercontent.com/u/45587025?v=4",
                    url: "https://github.com/JohannesNicholas",
                  ),
                  const PortfolioTile(
                    title: "LinkedIn",
                    image:
                        "https://media-exp1.licdn.com/dms/image/D5635AQEnN9V-BPIGTw/profile-framedphoto-shrink_200_200/0/1656923949439?e=1662714000&v=beta&t=wIrWCm_2xkeYztlQloAyQ-STD3CBRwCNtoPfNna2pwE",
                    url:
                        "https://www.linkedin.com/in/johannes-nicholas-541175230/",
                  ),
                  PortfolioTile(
                    title: "Itch.io",
                    image: corsProxy(
                        "https://img.itch.zone/aW1nLzk4OTExNTQuanBn/80x80%23/Ui%2FhT6.jpg"),
                    url: "https://johannesnicholas.itch.io/",
                  ),
                  PortfolioTile(
                    title: "Twitter",
                    image: corsProxy(
                        "https://pbs.twimg.com/profile_images/1535583474354388992/arWCWNsB_400x400.jpg"),
                    url: "https://twitter.com/goanna7007",
                  ),
                  PortfolioTile(
                    title: "StackOverflow",
                    image: corsProxy(
                        "https://i.stack.imgur.com/GRTWY.jpg?s=256&g=1"),
                    url:
                        "https://stackoverflow.com/users/6459409/joey-nicholas",
                  ),
                ],
              ]),
        ),
      ],
    );
  }
}

class FutureProjects extends StatelessWidget {
  const FutureProjects({
    Key? key,
    required this.futureChildren,
  }) : super(key: key);

  final Future<List<Widget>> futureChildren;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureChildren,
        builder: (context, snapshot) {
          return Row(
            children: [
              Expanded(
                child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    //alignment: WrapAlignment.center,
                    children: [
                      ...((snapshot.hasData)
                          ? snapshot.data as List<Widget>
                          : [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            ]),
                    ]),
              ),
            ],
          );
        });
  }
}

String corsProxy(String url) {
  return "https://us-central1-johannes-nicholas.cloudfunctions.net/getImage?url=" +
      Uri.encodeComponent(url);
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

Future<List<PortfolioTile>> extractGitHubData() async {
//Getting the response from the targeted url

  final functionURL =
      "https://us-central1-johannes-nicholas.cloudfunctions.net/getData?url=";

  final response = await http.Client()
      .get(Uri.parse(functionURL + 'https://github.com/JohannesNicholas'));
  //Status Code 200 means response has been received successfully
  if (response.statusCode == 200) {
    //Getting the html document from the response
    var document = parser.parse(response.body);
    try {
      var pinnedCells =
          document.getElementsByClassName('pinned-item-list-item');

      print(pinnedCells.length);

      List<PortfolioTile> tiles = [];

      for (var pinnedCell in pinnedCells) {
        var title = pinnedCell.getElementsByClassName("repo")[0].text.trim();

        var url = pinnedCell.getElementsByTagName("a")[0].attributes["href"];

        var imageUrl = "https://raw.githubusercontent.com/" +
            (url ?? "") +
            "/master/picture.png";

        tiles.add(PortfolioTile(
          title: title,
          image: corsProxy(imageUrl),
          url: "https://github.com" + (url ?? ""),
        ));
      }

      return tiles;

      //Converting the extracted titles into string and returning a list of Strings
      return pinnedCells.map((PinnedCell) {
        var title = PinnedCell.getElementsByClassName("repo")[0].text.trim();

        var url = PinnedCell.getElementsByTagName("a")[0].attributes["href"];

        var imageUrl = "https://raw.githubusercontent.com/" +
            (url ?? "") +
            "/master/picture.png";

        return PortfolioTile(
          title: title,
          image: imageUrl,
          url: "https://github.com" + (url ?? "JohannesNicholas"),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  } else {
    return [];
  }
}
