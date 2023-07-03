
extension IterableIndexed<E> on Iterable<E> {
  /// helper function to map an `Iterable<T>` to an `Iterable<E>`
  /// while also providing the index of the current item
  Iterable<T> mapIndexed<T>(
    T Function(int index, E item) f,
  ) sync* {
    var index = 0;

    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
