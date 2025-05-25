import 'package:flutter/material.dart';

void showConfirmationDialog({
  required BuildContext context,
  required int selectedCard,
  required bool isTrapSettingPhase,
  required bool isPlayer1Turn,
  required VoidCallback onConfirmed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        titlePadding: const EdgeInsets.only(top: 8, right: 8),
        title: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        content: SizedBox(
          width: 300,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isTrapSettingPhase? 'Player ${isPlayer1Turn ? 2 : 1} : $selectedCard にトラップをしかけてよろしいですか？': 'Player ${isPlayer1Turn ? 1 : 2} : $selectedCard でよろしいですか？',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmed();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('確認'),
              ),
            ],
          ),
        ),
      );
    },
  );
}