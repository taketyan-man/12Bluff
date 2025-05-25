import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'dart:math';

class CircleBoard extends StatelessWidget {
  final GameState gameState;
  final Function(int) onCardSelected;

  const CircleBoard({
    super.key,
    required this.gameState,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cardCount = 12;
    final double radius = 120;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < cardCount; i++)
            if (!gameState.usedCards.contains(i + 1))
              Positioned(
                left: 150 + radius * cos(i * 2 * pi / cardCount),
                top: 150 + radius * sin(i * 2 * pi / cardCount),
                child: ElevatedButton(
                  onPressed: () => onCardSelected(i + 1),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(gameState.message),
          ),
        ],
      ),
    );
  }
}
