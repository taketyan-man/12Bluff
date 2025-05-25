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
    final double buttonSize = 40;
    final double maxSize = 480;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenSize = min(constraints.maxWidth, constraints.maxHeight);
        final double size = min(screenSize, maxSize);
        final double radius = size / 2 - buttonSize;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // --- カード配置 ---
              ...List.generate(12, (i) {
                final angle = (2 * pi * i / 12) - pi / 3;
                final centerX = size / 2;
                final centerY = size / 2;
                final x = centerX + radius * cos(angle) - buttonSize / 2;
                final y = centerY + radius * sin(angle) - buttonSize / 2;
                final cardNumber = i + 1;
                final isUsed = !gameState.availableCards.contains(cardNumber);

                return Positioned(
                  left: x,
                  top: y,
                  child: SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: ElevatedButton(
                      onPressed: gameState.gameEnded || isUsed
                          ? null
                          : () => onCardSelected(cardNumber),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: isUsed ? Colors.grey : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('$cardNumber'),
                    ),
                  ),
                );
              }),

              // --- 中央メッセージ ---
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    gameState.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}