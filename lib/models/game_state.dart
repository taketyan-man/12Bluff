import 'package:flutter/material.dart';
import '../widgets/confirmation_dialog.dart';

class GameState {
  int player1Score = 0;
  int player2Score = 0;
  int player1TrapCount = 0;
  int player2TrapCount = 0;
  int? trapCard;
  String message = "Player2はトラップカードを選択してください";
  List<int> availableCards = List.generate(12, (i) => i + 1);
  List<String> player1Row = [];
  List<String> player2Row = [];
  List<int> usedCards = []; 
  bool isPlayer1Turn = true;
  bool isTrapSettingPhase = true;
  bool gameEnded = false;

  void handleCardSelection(BuildContext context, int selectedCard) {
    showConfirmationDialog(
      context: context,
      selectedCard: selectedCard,
      isTrapSettingPhase: isTrapSettingPhase,
      isPlayer1Turn: isPlayer1Turn,
      onConfirmed: () {
        if (isTrapSettingPhase) {
          trapCard = selectedCard;
          isTrapSettingPhase = false;
          message = "Player ${isPlayer1Turn ? 1 : 2} : はカードを選んでください";
        } else {
          _playTurn(selectedCard);
        }
      },
    );
  }

  void _playTurn(int selectedCard) {
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
      usedCards.add(selectedCard);
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
      message = "Player ${!isPlayer1Turn ? 1 : 2} : はトラップカードを選んでください";
      isTrapSettingPhase = true;
    }
  }

  void reset() {
    player1Score = 0;
    player2Score = 0;
    player1TrapCount = 0;
    player2TrapCount = 0;
    trapCard = null;
    isPlayer1Turn = true;
    isTrapSettingPhase = true;
    gameEnded = false;
    availableCards = List.generate(12, (i) => i + 1);
    usedCards.clear();
    player1Row.clear();
    player2Row.clear();
    message = "Player2はトラップカードを選択してください";
  }
}