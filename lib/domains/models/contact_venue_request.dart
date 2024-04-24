import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'contact_venue_request.freezed.dart';
part 'contact_venue_request.g.dart';

@freezed
class ContactVenueRequest with _$ContactVenueRequest {
  @JsonSerializable(explicitToJson: true)
  const factory ContactVenueRequest({
    required UserModel venue,
    required UserModel user,
    required String bookingEmail,
    required String note,
    @DateTimeConverter() required DateTime timestamp,
    @Default(None()) Option<String> originalMessageId,
    @Default(None()) Option<String> latestMessageId,
    @Default(None()) Option<String> subject,
    @Default([]) List<String> allEmails,
    @Default([]) List<UserModel> collaborators,
  }) = _ContactVenueRequest;

  factory ContactVenueRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactVenueRequestFromJson(json);
}
