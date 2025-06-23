import 'package:flutter/material.dart';
import 'package:numbers_test/services/local_storage.dart';


class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<String> _savedInfo = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final saved = await LocalStorageService.getSavedInfo();
    setState(() {
      _savedInfo = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сохранённые данные'),
      ),
      body: _savedInfo.isEmpty
          ? Center(child: Text('Нет сохранённых данных'))
          : ListView.builder(
        itemCount: _savedInfo.length,
        itemBuilder: (context, index) {
          final info = _savedInfo[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(info),
            ),
          );
        },
      ),
    );
  }
}
