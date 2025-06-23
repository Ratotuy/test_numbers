import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:numbers_test/services/local_storage.dart';
import 'package:numbers_test/utils/validator.dart';
import '../services/api_service.dart';
import '../widgets/info_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _selectedType = 'trivia';
  bool _isRandom = false;
  bool _isLoading = false;

  final List<String> _types = ['trivia', 'math', 'date'];

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchAndShowInfo() async {
    FocusScope.of(context).unfocus();
    final numberText = _numberController.text.trim();

    if (!_isRandom) {
      if (_selectedType == 'date') {
        if (!isValidDateFormat(numberText)) {
          _showError('Дата должна быть в формате MM/DD');
          return;
        }
      } else {
        if (!isValidNumber(numberText)) {
          _showError('Число должно быть в виде цифры');
          return;
        }
      }
    }

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _showError('Нет подключения к интернету');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final number = _isRandom
          ? null
          : (_selectedType == 'date' ? numberText : int.parse(numberText));

      final info = await ApiService.fetchNumberInfo(
        number: number,
        type: _selectedType,
        isRandom: _isRandom,
      );

      setState(() => _isLoading = false);

      showDialog(
        context: context,
        builder: (_) => InfoModal(
          info: info,
          onSave: () async {
            await LocalStorageService.saveInfo(info);
            Navigator.of(context).pop();
            _showError('Сохранено');
          },
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Ошибка получения данных');
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputHint = _selectedType == 'date' ? 'MM/DD (например, 2/14)' : 'Введите число';

    return Scaffold(
      appBar: AppBar(
        title: Text('Number Info'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, '/saved'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxListTile(
              value: _isRandom,
              title: Text('Случайное число'),
              onChanged: (val) {
                setState(() {
                  _isRandom = val ?? false;
                });
              },
            ),
            if (!_isRandom)
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: inputHint,
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedType = val;
                    _numberController.clear(); // очищаем поле при смене типа
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Тип информации',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchAndShowInfo,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Получить информацию'),
            ),
          ],
        ),
      ),
    );
  }
}
