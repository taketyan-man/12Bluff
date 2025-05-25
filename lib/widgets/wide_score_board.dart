import 'package:flutter/material.dart';
import '../models/game_state.dart';

class WideScoreBoard extends StatelessWidget {
  final GameState gameState;

  const WideScoreBoard({Key? key, required this.gameState}) : super(key: key);

  Widget _buildPlayer(String title, List<String> values, int score, int traps) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: values.map((v) => Chip(label: Text(v))).toList(),
          ),
          Text("スコア: $score ❌: $traps"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayer("Player 1", gameState.player1Row, gameState.player1Score, gameState.player1TrapCount),
        const SizedBox(width: 32),
        _buildPlayer("Player 2", gameState.player2Row, gameState.player2Score, gameState.player2TrapCount),
      ],
    );
  }
}