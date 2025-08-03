import 'package:flutter/material.dart';

import 'game_screen.dart';
import 'home_screen.dart';
class ResultScreen extends StatefulWidget {
  final String winner;
  final bool isDraw;

  ResultScreen({required this.winner, required this.isDraw});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _confettiController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));

    _bounceController.forward();
    if (!widget.isDraw) {
      _confettiController.forward();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDraw
                ? [Colors.orange.shade300, Colors.yellow.shade200]
                : [Colors.green.shade400, Colors.blue.shade300],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ScaleTransition(
              scale: _bounceAnimation,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Result Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isDraw ? Icons.handshake : Icons.emoji_events,
                        size: 60,
                        color: widget.isDraw ? Colors.orange : Colors.amber,
                      ),
                    ),

                    SizedBox(height: 30),

                    // Result Text
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.isDraw ? "It's a Draw!" : "Player ${widget.winner} Wins!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: widget.isDraw ? Colors.orange.shade700 : Colors.green.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.isDraw
                                ? "Great game! Nobody wins this time."
                                : "Congratulations on your victory!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50),

                    // Action Buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => GameScreen()),
                              );
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Play Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade700,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                                    (route) => false,
                              );
                            },
                            icon: Icon(Icons.home),
                            label: Text('Back to Home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              foregroundColor: Colors.grey.shade700,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}