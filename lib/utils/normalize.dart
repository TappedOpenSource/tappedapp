
List<double> normalize(List<int> values) {
  if (values.isEmpty) {
    return [];
  }

  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);

  return values.map((value) => (value - minValue) / (maxValue - minValue)).toList();
}