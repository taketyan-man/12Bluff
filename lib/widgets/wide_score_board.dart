import 'package:flutter/material.dart';
import '../models/game_state.dart';

class WideScoreBoard extends StatelessWidget {
  final GameState gameState;

  const WideScoreBoard({super.key, required this.gameState});

  static const int totalTurns = 9;
  static const double cellHeight = 30;
  static const double nameRatio = 0.2;
  static const double cellRatio = 0.8 / 10;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth * 0.95;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildRow(
                playerName: "Player 1",
                scores: gameState.player1Row,
                totalScore: gameState.player1Score,
                totalWidth: totalWidth,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildRow(
                playerName: "Player 2",
                scores: gameState.player2Row,
                totalScore: gameState.player2Score,
                totalWidth: totalWidth,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildRow({
    required String playerName,
    required List<String> scores,
    required int totalScore,
    required double totalWidth,
  }) {
    List<String> fixedScores = List<String>.filled(totalTurns, '', growable: true);
    for (int i = 0; i < scores.length && i < totalTurns; i++) {
      fixedScores[i] = scores[i];
    }
    fixedScores.add(totalScore.toString());

    List<String> rowContents = [playerName] + fixedScores;

    return rowContents.asMap().entries.map((entry) {
      final index = entry.key;
      final text = entry.value;
      final isName = index == 0;
      final isLast = index == rowContents.length - 1;

      final width = isName
          ? totalWidth * nameRatio
          : totalWidth * cellRatio;

      return Container(
        width: width,
        height: cellHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLast ? Colors.yellow[200] : Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isName ? FontWeight.bold : FontWeight.normal,
            color: text == '❌' ? Colors.red : Colors.black,
          ),
        ),
      );
    }).toList();
  }
}