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
  int player1trapCount = 0;
  int player2trapCount = 0;
  int? trapCard;
  String message = "Player2はトラップカードを選択してください";
  List<int> usedCards = [];
  bool isPlayer1Turn =      true; // true: プレイヤー1が攻め
  bool isTrapSettingPhase = true; // true: まだ守り手がトラップを選び中

  void playTurn(int selectedCard) {
    setState(() {
      if (selectedCard == trapCard) {
        // トラップヒット！
        if (isPlayer1Turn) {
          player1Score = 0;
          player1trapCount += 1;
        } else {
          player2Score = 0;
          player2trapCount += 1;
        }
        
        message = "トラップに引っかかった！ポイント没収...";
      } else {
        if (isPlayer1Turn) {
          player1Score += selectedCard;

        } else {
          player2Score += selectedCard;
        }
        usedCards.add(selectedCard);
        message = "$selectedCardポイント獲得！";
      }

      if (player1Score >= 40 || player2Score >= 40 || player1trapCount >= 3 || player2trapCount >= 3) {
        message += "\nゲーム終了";
      } else {
        isPlayer1Turn = !isPlayer1Turn;
      }
      message = "Player ${!isPlayer1Turn ? 1 : 2} はトラップカードを選んでください";
      isTrapSettingPhase = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("12Bluff")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("攻め手: ${isPlayer1Turn ? "Player 1" : "Player 2"}", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text("Player 1: $player1Score 点"),
          Text("Player 2: $player2Score 点"),
          Text("プレイヤー１トラップ回数: $player1trapCount / 3"),
          Text("プレイヤー２トラップ回数: $player2trapCount / 3"),
          const SizedBox(height: 20),

          Wrap(
            spacing: 8,
            children: List.generate(12, (i) {
              final num = i + 1;
              return ElevatedButton(
                onPressed: () {
                  if (isTrapSettingPhase) {
                    setState( () {
                      trapCard = num;
                      isTrapSettingPhase = false;
                      message = "Player ${isPlayer1Turn ? 1 : 2}はカードを選んでください";
                    });
                  } else {
                    playTurn(num);
                  }
                },
                child: Text(num.toString()),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
