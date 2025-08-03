import 'package:flutter/material.dart';
import 'package:tictaktoe/screens/result_screen.dart';
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;
  List<int> winningLine = [];

  late AnimationController _cellController;
  late AnimationController _winController;
  late Animation<double> _cellAnimation;
  late Animation<double> _winAnimation;

  @override
  void initState() {
    super.initState();

    _cellController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _winController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _cellAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cellController,
      curve: Curves.bounceOut,
    ));

    _winAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _winController,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _cellController.dispose();
    _winController.dispose();
    super.dispose();
  }

  void makeMove(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        _cellController.forward();

        if (checkWinner()) {
          winner = currentPlayer;
          gameOver = true;
          _winController.repeat(reverse: true);

          // Navigate to results screen after a delay
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  winner: winner,
                  isDraw: false,
                ),
              ),
            );
          });
        } else if (board.every((cell) => cell != '')) {
          winner = 'Draw';
          gameOver = true;

          // Navigate to results screen after a delay
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  winner: '',
                  isDraw: true,
                ),
              ),
            );
          });
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (List<int> pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        winningLine = pattern;
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
      winningLine = [];
    });
    _winController.reset();
  }

  Color getCellColor(int index) {
    if (winningLine.contains(index)) {
      return Colors.green.shade100;
    }
    return Colors.white;
  }

  Color getCellBorderColor(int index) {
    if (winningLine.contains(index)) {
      return Colors.green;
    }
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Status
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _winAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: gameOver ? _winAnimation.value : 1.0,
                      child: Text(
                        gameOver
                            ? (winner == 'Draw' ? "It's a Draw!" : "$winner Wins!")
                            : "Player $currentPlayer's Turn",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: gameOver
                              ? (winner == 'Draw' ? Colors.orange : Colors.green)
                              : Colors.blue.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              // Game Board
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => makeMove(index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: getCellColor(index),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: getCellBorderColor(index),
                                width: winningLine.contains(index) ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _cellAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: board[index] != '' ? _cellAnimation.value : 1.0,
                                    child: Text(
                                      board[index],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: board[index] == 'X'
                                            ? Colors.blue.shade600
                                            : Colors.red.shade600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: resetGame,
                    icon: Icon(Icons.refresh),
                    label: Text('Restart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}