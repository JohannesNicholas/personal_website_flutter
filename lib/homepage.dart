import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const tileSize = 200.0;

class HomePage extends StatefulWidget {
  int _counter = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                //alignment: WrapAlignment.center,
                children: <Widget>[
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                  PortfolioTile(),
                ]),
          ),
        ],
      ),
    );
  }
}

class PortfolioTile extends StatelessWidget {
  // a square tile with a title and background image to display one of my projects
  const PortfolioTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
            color: Colors.orange,
            height: tileSize,
            width: tileSize,
            child: Center(child: Text('Portfolio Tile'))),
      );
    });
  }
}
