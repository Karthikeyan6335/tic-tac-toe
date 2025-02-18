import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TicTacToeHome(),
    );
  }
}

class TicTacToeHome extends StatefulWidget {
  @override
  _TicTacToeHomeState createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  static const int gridSize = 3;
  List<List<String>> board = List.generate(gridSize, (_) => List.filled(gridSize, ''));
  String currentPlayer = 'X';
  int xScore = 0;
  int oScore = 0;

  void _handleTap(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner()) {
          _showWinnerDialog('$currentPlayer Wins!');
        } else if (_isBoardFull()) {
          _showWinnerDialog('It\'s a Draw!');
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner() {
    for (int i = 0; i < gridSize; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != '') return true;
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != '') return true;
    }
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != '') return true;
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != '') return true;
    return false;
  }

  bool _isBoardFull() {
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
  }

  void _showWinnerDialog(String message) {
    if (message.contains('Wins')) {
      if (currentPlayer == 'X') xScore++;
      else oScore++;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
              },
            ),
            TextButton(
              child: Text('Reset Scores'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
                setState(() {
                  xScore = 0;
                  oScore = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _resetBoard() {
    setState(() {
      board = List.generate(gridSize, (_) => List.filled(gridSize, ''));
      currentPlayer = 'X';
    });
  }

  Widget _buildBoard() {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          childAspectRatio: 1.0,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (BuildContext context, index) {
          int row = index ~/ gridSize;
          int col = index % gridSize;
          return GestureDetector(
            onTap: () => _handleTap(row, col),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.black, // Black background for tiles
              ),
              child: Center(
                child: Text(
                  board[row][col],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18), // Black background for the entire app
      appBar: AppBar(
        title: Center(child: Text('TIC-TAC-TOE')), // Title centered
        backgroundColor: Colors.blue, // App bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Player 1: $xScore - Player 2: $oScore',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildBoard(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetBoard,
              child: Text('Restart Game', style: TextStyle(fontSize: 25,color: Color.fromARGB(255, 35, 146, 35)),),
            ),
          ],
        ),
      ),
    );
  }
}
