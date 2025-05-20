import 'package:flutter/cupertino.dart';
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
  List<String> player1Row = [];
  List<String> player2Row = [];
  bool isPlayer1Turn = true;
  bool isTrapSettingPhase = true;
  bool gameEnded = false;

  void playTurn(int selectedCard) {
    setState(() {
      if (selectedCard == trapCard) {
        if (isPlayer1Turn) {
          player1Score = 0;
          player1TrapCount += 1;
          player1Row.add('❌');
        } else {
          player2Score = 0;
          player2TrapCount += 1;
          player2Row.add('❌');
        }
        message = "トラップに引っかかった！ポイント没収...";
      } else {
        if (isPlayer1Turn) {
          player1Score += selectedCard;
          player1Row.add('$selectedCard');
        } else {
          player2Score += selectedCard;
          player2Row.add('$selectedCard');
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

                return Positioned(
                  left: x,
                  top: y,
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
                                  message = "Player ${isPlayer1Turn ? 1 : 2} はカードを選んでください";
                                });
                              } else {
                                playTurn(i + 1);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: availableCards.contains(i + 1) ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('${i + 1}'),
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
                    message,
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

  Widget buildWideScoreBoard() {
    const double cellHeight = 30;
    const int totalTurns = 9;
    const double nameRatio = 0.2;
    const double cellRatio = 0.8 / 10; // 9 turns + 1 total
 // ← 任意のスコアをここで定義

    List<Widget> buildRow({
      required String playerName,
      required List<String> scores,
      required double totalWidth,
      String? overrideLastCellText,
      Color? lastCellColor,
    }) {
      List<String> fixedScores = List<String>.filled(totalTurns, '', growable: true);

      for (int i = 0; i < scores.length && i < totalTurns; i++) {
        fixedScores[i] = scores[i];
      }

      int total = scores.fold(0, (sum, s) {
        if (s == '❌') return sum;
        final parsed = int.tryParse(s);
        return sum + (parsed ?? 0);
      });

      // 通常時は合計スコアを最後のセルに追加
      fixedScores.add(overrideLastCellText ?? total.toString());

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
            color: isLast
                ? (lastCellColor ?? Colors.white)
                : Colors.white,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth * 0.8;
        return Column (
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: buildRow(
                  playerName: "Player 1",
                  scores: player1Row,
                  overrideLastCellText: '$player1Score',
                  totalWidth: totalWidth,
                  lastCellColor: Colors.yellow[200],
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: buildRow(
                  playerName: "Player 2",
                  scores: player2Row,
                  totalWidth: totalWidth,
                  overrideLastCellText: '$player2Score',
                  lastCellColor: Colors.yellow[200], // 背景を黄色に
                ),
              ),
            ),    
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("12Bluff")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircleBoard(),
            const SizedBox(height: 20),
            if (screenWidth < 600)
              buildScoreBoard()
            else
              buildWideScoreBoard(),
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
