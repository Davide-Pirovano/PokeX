// Estensione per rendere maiuscola la prima lettera del nome
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
