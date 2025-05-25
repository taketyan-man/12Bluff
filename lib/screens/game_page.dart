import 'package:flutter/material.dart';
import '../widgets/circle_board.dart';
import '../widgets/score_board.dart';
import '../widgets/wide_score_board.dart';
import '../models/game_state.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameState gameState = GameState();

  void onCardSelected(int selectedCard) {
    setState(() {
      gameState.handleCardSelection(context, selectedCard);
    });
  }

  void resetGame() {
    setState(() {
      gameState.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("12Bluff")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleBoard(
              gameState: gameState,
              onCardSelected: onCardSelected,
            ),
            const SizedBox(height: 20),
            if (screenWidth < 600)
              ScoreBoard(gameState: gameState)
            else
              WideScoreBoard(gameState: gameState),
            if (gameState.gameEnded)
              ElevatedButton(
              onPressed: resetGame,
              child: const Text("ゲームをリスタート"),
            ),
          ],
        ),
      ),
    );
  }
}

