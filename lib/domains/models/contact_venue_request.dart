
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'contact_venue_request.freezed.dart';
part 'contact_venue_request.g.dart';

@freezed
class ContactVenueRequest with _$ContactVenueRequest {
  const factory ContactVenueRequest({
    required UserModel venue,
    required UserModel user,
    required String bookingEmail,
    required String note,
    @DateTimeConverter() required DateTime timestamp,
    @Default(None()) Option<String> messageId,
    @Default([]) List<String> allEmails,
  }) = _ContactVenueRequest;

  factory ContactVenueRequest.fromJson(Map<String, dynamic> json) => _$ContactVenueRequestFromJson(json);
}