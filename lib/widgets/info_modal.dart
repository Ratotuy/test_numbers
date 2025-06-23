import 'package:flutter/material.dart';

class InfoModal extends StatelessWidget {
  final String info;
  final VoidCallback onSave;

  const InfoModal({
    required this.info,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Информация о числе'),
      content: SingleChildScrollView(
        child: Text(info),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Закрыть'),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}
