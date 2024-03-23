import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';

part 'service.g.dart';

@freezed
class Service with _$Service {
  const factory Service({
    required String id,
    required String userId,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int rate,
    @Default(RateType.fixed) RateType rateType,
    @Default(0) int count,
    @Default(false) bool deleted,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  factory Service.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    return Service.fromJson(data);
  }
}

enum RateType {
  @JsonValue('hourly')
  hourly,
  @JsonValue('fixed')
  fixed,
}

extension ServiceX on Service {
  int performerCost(DateTime startTime, DateTime endTime) {
    if (rateType == RateType.fixed) {
      return rate;
    }

    final d = endTime.difference(startTime);
    final rateInMinutes = rate / 60;
    final total = d.inMinutes * rateInMinutes;

    return total.toInt();
  }
}
