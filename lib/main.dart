import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(home: GamePage()));
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int player1Score = 0;
  int player2Score = 0;
  int player1TrapCount = 0;
  int player2TrapCount = 0;
  int? trapCard;
  String message = "Player2はトラップカードを選択してください";
  List<int> availableCards = List.generate(12, (i) => i + 1);
  bool isPlayer1Turn = true;
  bool isTrapSettingPhase = true;
  bool gameEnded = false;

  void playTurn(int selectedCard) {
    setState(() {
      if (selectedCard == trapCard) {
        if (isPlayer1Turn) {
          player1Score = 0;
          player1TrapCount += 1;
        } else {
          player2Score = 0;
          player2TrapCount += 1;
        }
        message = "トラップに引っかかった！ポイント没収...";
      } else {
        if (isPlayer1Turn) {
          player1Score += selectedCard;
        } else {
          player2Score += selectedCard;
        }
        availableCards.remove(selectedCard);
        message = "$selectedCardポイント獲得！";
      }

      if (player1Score >= 40 || player2Score >= 40 || player1TrapCount >= 3 || player2TrapCount >= 3 || availableCards.length == 1) {
        if (player1TrapCount >= 3) {
          message += "\nPlayer 2 の勝ち！";
        } else if (player2TrapCount >= 3) {
          message += "\nPlayer 1 の勝ち！";
        } else if (player1Score > player2Score) {
          message += "\nPlayer 1 の勝ち！";
        } else if (player2Score > player1Score) {
          message += "\nPlayer 2 の勝ち！";
        } else {
          message += "\n引き分け！";
        }
        gameEnded = true;
      } else {
        isPlayer1Turn = !isPlayer1Turn;
        message = "Player ${!isPlayer1Turn ? 1 : 2} はトラップカードを選んでください";
        isTrapSettingPhase = true;
      }
    });
  }

  void resetGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
      player1TrapCount = 0;
      player2TrapCount = 0;
      trapCard = null;
      isPlayer1Turn = true;
      isTrapSettingPhase = true;
      gameEnded = false;
      availableCards = List.generate(12, (i) => i + 1);
      message = "Player2 はトラップカードを選択してください";
    });
  }

  Widget buildCircleBoard() {
    final double radius = 180;
    final double buttonSize = 40;

    return SizedBox(
      width: 2 * radius + buttonSize + 40,  // 少し余裕を持たせる
      height: 2 * radius + buttonSize + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // カード配置
          for (int i = 0; i < 12; i++) ...[
            Positioned(
              left: radius * cos((2 * pi * i / 12) - pi / 3) + (radius + buttonSize / 2) - (buttonSize / 3),
              top: radius * sin((2 * pi * i / 12) - pi / 3) + (radius + buttonSize / 2),
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: ElevatedButton(
                  onPressed: gameEnded || !availableCards.contains(i + 1)
                      ? null
                      : () {
                          if (isTrapSettingPhase) {
                            setState(() {
                              trapCard = i + 1;
                              isTrapSettingPhase = false;
                              message =
                                  "Player ${isPlayer1Turn ? 1 : 2} はカードを選んでください";
                            });
                          } else {
                            playTurn(i + 1);
                          }
                        },
                  child: Text('${i + 1}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: availableCards.contains(i + 1)
                    ? Colors.blue
                    : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero, // サイズ調整
                  ),
                ),
              ),
            ),
          ],

      // 中央メッセージ
          Container(
            padding: const EdgeInsets.all(12),
            width: 180,
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScoreBoard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Player 1: $player1Score 点"),
              Text("Trap: $player1TrapCount / 3"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Player 2: $player2Score 点"),
              Text("Trap: $player2TrapCount / 3"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("12Bluff")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircleBoard(),
            const SizedBox(height: 20),
            buildScoreBoard(),
            if (gameEnded)
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
