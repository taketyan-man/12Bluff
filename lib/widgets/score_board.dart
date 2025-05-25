import 'package:flutter/material.dart';
import '../models/game_state.dart';

class ScoreBoard extends StatelessWidget {
  final GameState gameState;

  const ScoreBoard({Key? key, required this.gameState}) : super(key: key);

  Widget _buildRow(String title, List<String> values, int score, int traps) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: values.map((v) => Chip(label: Text(v))).toList(),
        ),
        Text("スコア: $score ❌: $traps"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow("Player 1", gameState.player1Row, gameState.player1Score, gameState.player1TrapCount),
        const SizedBox(height: 16),
        _buildRow("Player 2", gameState.player2Row, gameState.player2Score, gameState.player2TrapCount),
      ],
    );
  }
}


