// Estensione per rendere maiuscola la prima lettera del nome
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

formatToKg(int weight) {
  return (weight / 10).toStringAsFixed(1);
}

formatToMeters(int height) {
  return (height / 10).toStringAsFixed(1);
}
