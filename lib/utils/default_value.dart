
import 'package:cloud_firestore/cloud_firestore.dart';

/// project extensions for firebase's `DocumentSnapshot<T>` class
extension DefaultValue<V> on DocumentSnapshot<Map<String, dynamic>> {
  /// helper function to try an index the `DocumentSnapshot<T>` object
  /// and return a custom default value if the desired index doesn't exist
  ///
  /// This is useful for adding new fields to DB models since it means
  /// a custom migration script doesn't need to be made every time
  /// and can instead just set its default client-side
  V getOrElse(String key, V defaultValue) {
    final data = this.data();

    return data != null && data.containsKey(key)
        ? (data[key] ?? defaultValue) as V
        : defaultValue;
  }
}
