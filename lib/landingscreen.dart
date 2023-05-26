import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reset Total Wins'),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _db.put('xtotal', 0);
                              _db.put('ototal', 0);
                            });
                          },
                          child: const Text('Reset'))
                    ]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _db = Hive.box('dbBox');

  @override
  Widget build(BuildContext context) {
    int? owins = _db.get('ototal');
    int? xwins = _db.get('xtotal');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        elevation: 10,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 400,
                width: 400,
                child: Image.asset('assets/images/image.png')),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.pushNamed(context, "Game/");
                  Navigator.popAndPushNamed(context, "Game/");
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text("Total Wins", style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'X: $xwins',
                  style: const TextStyle(fontSize: 40),
                ),
                const Divider(
                  height: 50,
                  thickness: 2,
                ),
                Text(
                  'O: $owins',
                  style: const TextStyle(fontSize: 40),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        child: const Icon(Icons.settings),
      ),
    );
  }
}
