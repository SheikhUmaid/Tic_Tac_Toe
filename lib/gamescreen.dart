import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Game extends StatefulWidget {
  const Game({super.key});
  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int xwins = 0;
  int owins = 0;
  final _db = Hive.box('dbBox');

  String audioPath = "assets/audios/click.mp3";
  var grid = [
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
  ];

  void reset() {
    setState(() {
      grid = [
        '-',
        '-',
        '-',
        '-',
        '-',
        '-',
        '-',
        '-',
        '-',
      ];
      currentPlayer = "X";
    });
  }

  String currentPlayer = 'X';
  void drawXO(i) {
    if (grid[i] == '-') {
      setState(() {
        grid[i] = currentPlayer;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      });
      checkWinner(grid[i]);
    }
  }

  bool checkMove(i1, i2, i3, sign) {
    if (grid[i1] == sign && grid[i2] == sign && grid[i3] == sign) {
      return true;
    } else {
      return false;
    }
  }

  void checkWinner(player) {
    if (checkMove(0, 1, 2, player) ||
        checkMove(3, 4, 5, player) ||
        checkMove(6, 7, 8, player) ||
        checkMove(0, 3, 6, player) ||
        checkMove(1, 4, 7, player) ||
        checkMove(2, 5, 8, player) ||
        checkMove(0, 4, 8, player) ||
        checkMove(2, 4, 6, player)) {
      if (player == 'X') {
        xwins += 1;
        if (_db.get('xtotal') == null) {
          _db.put('xtotal', 0);
        } else {
          _db.put('xtotal', _db.get('xtotal') + 1);
        }
      }
      if (player == 'O') {
        owins += 1;
        if (_db.get('ototal') == null) {
          _db.put('ototal', 0);
        } else {
          _db.put('ototal', _db.get('ototal') + 1);
        }
      }
      _showMyDialog(player);
    }
  }

  Future<void> _showMyDialog(winer) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Winner'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$winer won!'),
                const Text('Would you like to reset?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                Navigator.of(context).pop();
                reset();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/');
            },
            color: Colors.black),
        backgroundColor: Colors.amber,
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text("Wins", style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'X: $xwins',
                style: const TextStyle(fontSize: 50),
              ),
              const Divider(
                height: 50,
              ),
              Text(
                'O: $owins',
                style: const TextStyle(fontSize: 50),
              ),
            ],
          ),
          const Spacer(),
          Container(
            color: Colors.black,
            margin: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: grid.length,
              itemBuilder: (context, index) => Material(
                color: Colors.amber,
                child: InkWell(
                  splashColor: Colors.black,
                  onTap: () => drawXO(index),
                  child: Center(
                    child: Text(
                      grid[index],
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: reset,
              child: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.refresh),
                    Text('Reset'),
                  ],
                ),
              )),
          const Spacer(),
        ],
      ),
    );
  }
}
