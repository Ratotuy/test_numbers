/// Проверка, является ли введённая строка корректным числом
bool isValidNumber(String input) {
  return int.tryParse(input) != null;
}

/// Проверка, является ли строка датой в формате "MM/DD"
bool isValidDateFormat(String input) {
  final parts = input.split('/');
  if (parts.length != 2) return false;

  final month = int.tryParse(parts[0]);
  final day = int.tryParse(parts[1]);

  if (month == null || day == null) return false;

  return month >= 1 && month <= 12 && day >= 1 && day <= 31;
}
