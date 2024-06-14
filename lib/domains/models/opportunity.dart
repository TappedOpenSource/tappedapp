import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/location.dart';

part 'opportunity.freezed.dart';
part 'opportunity.g.dart';

@freezed
class Opportunity with _$Opportunity {
  @JsonSerializable(explicitToJson: true)
  const factory Opportunity({
    required String id,
    required String userId,
    required Location location,
    @DateTimeConverter() required DateTime timestamp,
    @DateTimeConverter() required DateTime startTime,
    @DateTimeConverter() required DateTime endTime,
    @Default('') String title,
    @Default('') String description,
    @Default(None()) Option<String> flierUrl,
    @Default(false) bool isPaid,
    @Default(None()) Option<OpportunityInteraction> touched,
    @Default(false) bool deleted,
    @Default(None()) Option<String> venueId,
  }) = _Opportunity;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);

  factory Opportunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    return Opportunity.fromJson(data);
  }
}

@JsonEnum()
enum OpportunityInteraction {
  @JsonValue('like')
  like,
  @JsonValue('dislike')
  dislike,
}
