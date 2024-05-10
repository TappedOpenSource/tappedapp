
/// recursively convert the map tp Map<String,dynamic>
Map<String, dynamic> convertMap(Map<dynamic, dynamic> map) {
  for (final key in map.keys) {
    if (map[key] is Map) {
      map[key] = convertMap(map[key] as Map<dynamic, dynamic>);
    } else if (map[key] is List) {
      map[key] = map[key].map((e) {
        if (e is Map) {
          return convertMap(e);
        }
        return e;
      }).toList();
    }
  }
  return Map<String, dynamic>.from(map);
}