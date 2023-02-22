import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:async';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  Future<void> loadAssets() async {
    await FlameAudio.audioCache.loadAll(['background_audio.mp3']);
    await precacheImage(AssetImage("assets/images/background.jpg"), context);
    await precacheImage(AssetImage("assets/images/mute.png"), context);
    await precacheImage(AssetImage("assets/images/volume.png"), context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadAssets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TicTacToeHome();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Loading..."),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class TicTacToeHome extends StatefulWidget {
  @override
  _TicTacToeHomeState createState() => _TicTacToeHomeState();
}
class _TicTacToeHomeState extends State<TicTacToeHome> {
  late List<List<String>> board;
  late String player;
  late String winner;



  @override
  void initState() {
    super.initState();
    board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ""));
    player = "X";
    winner = "";
  }

  void play(int row, int col) {
    if (board[row][col].isNotEmpty) {
      return;
    }
    if (winner.isNotEmpty ||
        board.expand((element) => element).every((e) => e.isNotEmpty)) {
      return;
    }
    setState(() {
      if (winner.isNotEmpty) {
        return;
      }

      board[row][col] = player;

      if (checkWinningCondition(row, col)) {
        winner = player;
      } else {
        player = (player == "X") ? "O" : "X";
      }
    });
  }

  bool checkWinningCondition(int row, int col) {
    String symbol = board[row][col];

// Check the row
    for (int i = 0; i < 3; i++) {
      if (board[row][i] != symbol) {
        break;
      }
      if (i == 2) {
        return true;
      }
    }

// Check the column
    for (int i = 0; i < 3; i++) {
      if (board[i][col] != symbol) {
        break;
      }
      if (i == 2) {
        return true;
      }
    }

// Check the left-to-right diagonal
    if (row == col) {
      for (int i = 0; i < 3; i++) {
        if (board[i][i] != symbol) {
          break;
        }
        if (i == 2) {
          return true;
        }
      }
    }

// Check the right-to-left diagonal
    if (row + col == 2) {
      for (int i = 0; i < 3; i++) {
        if (board[i][2 - i] != symbol) {
          break;
        }
        if (i == 2) {
          return true;
        }
      }
    }

    return false;
  }

  void reset() {
    setState(() {
      board = List<List<String>>.generate(3, (_) => List<String>.filled(3, ""));
      player = "X";
      winner = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tic Tac Toe",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 693,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan, Colors.black],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.jpg"),
                        fit: BoxFit.cover)),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () => play(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          color: (checkWinningCondition(row, col) && board[row][col] == player)
                              ? Colors.green[500]
                              : Colors.transparent,
                          border: Border.all(color: Colors.black),
                        ),


                        // color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            board[row][col] ?? "",
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,bottom: 0, top: 20),
              width: double.infinity,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  winner.isNotEmpty ||
                      board.expand((element) => element).every((e) => e.isNotEmpty)
                      ? "Game Over"
                      : "$player has to play next",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              height: 223,
              child: Center(
                child: Text(
                  winner.isNotEmpty
                      ? "The winner is $winner"
                      : (board
                      .expand((element) => element)
                      .every((e) => e.isNotEmpty)
                      ? "Draw"
                      : ""),
                  style: TextStyle(fontSize: 30,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10,bottom: 0),
                alignment: Alignment.bottomLeft,
                child: SwitchScreen()
            ),
          ],
        ),
      ),),

      floatingActionButton: FloatingActionButton(
        onPressed: reset,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('background_audio.mp3');
  }

  void musicStop() {
    FlameAudio.bgm.pause();
  }

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        startBgmMusic();
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
        musicStop();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ Transform.scale(
            scale: 2,
            child: Container(
              margin: EdgeInsets.only(left: 30,bottom: 18),
              child: Switch(
                onChanged: toggleSwitch,
                value: isSwitched,
                activeColor: Colors.transparent,
                activeTrackColor: Colors.cyan,
                // inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.grey,
                activeThumbImage: AssetImage('assets/images/volume.png'),
                inactiveThumbImage: AssetImage('assets/images/mute.png'),

              ),
            )

        ),
        ]);
  }
}
