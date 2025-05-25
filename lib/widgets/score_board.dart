import 'package:flutter/material.dart';
import '../models/game_state.dart';

class ScoreBoard extends StatelessWidget {
  final GameState gameState;

  const ScoreBoard({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const Text("スコアボード", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildScoreRow("Player 1", gameState.player1Score, gameState.player1TrapCount),
          const SizedBox(height: 6),
          _buildScoreRow("Player 2", gameState.player2Score, gameState.player2TrapCount),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String name, int score, int trapCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("$name: $score 点"),
        Text("Trap: $trapCount / 3"),
      ],
    );
  }
}