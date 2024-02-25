import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Genre {
  @JsonValue('pop')
  pop,
  @JsonValue('rock')
  rock,
  @JsonValue('hiphop')
  hiphop,
  @JsonValue('rap')
  rap,
  @JsonValue('rnb')
  rnb,
  @JsonValue('country')
  country,
  @JsonValue('edm')
  edm,
  @JsonValue('jazz')
  jazz,
  @JsonValue('latin')
  latin,
  @JsonValue('classical')
  classical,
  @JsonValue('reggae')
  reggae,
  @JsonValue('blues')
  blues,
  @JsonValue('soul')
  soul,
  @JsonValue('funk')
  funk,
  @JsonValue('metal')
  metal,
  @JsonValue('punk')
  punk,
  @JsonValue('indie')
  indie,
  @JsonValue('folk')
  folk,
  @JsonValue('alternative')
  alternative,
  @JsonValue('other')
  other,
}

extension GenreX on Genre {
  String get formattedName {
    return switch (this) {
      Genre.pop => 'Pop',
      Genre.rock => 'Rock',
      Genre.hiphop => 'Hip Hop',
      Genre.rap => 'Rap',
      Genre.rnb => 'R&B',
      Genre.country => 'Country',
      Genre.edm => 'EDM',
      Genre.jazz => 'Jazz',
      Genre.latin => 'Latin',
      Genre.classical => 'Classical',
      Genre.reggae => 'Reggae',
      Genre.blues => 'Blues',
      Genre.soul => 'Soul',
      Genre.funk => 'Funk',
      Genre.metal => 'Metal',
      Genre.punk => 'Punk',
      Genre.indie => 'Indie',
      Genre.folk => 'Folk',
      Genre.alternative => 'Alternative',
      Genre.other => 'Other',
    };
  }

  IconData get icon {
    return switch (this) {
      Genre.pop => FontAwesomeIcons.fire,
      Genre.rock => FontAwesomeIcons.drum,
      Genre.hiphop => FontAwesomeIcons.microphone,
      Genre.rap => FontAwesomeIcons.microphoneLines,
      Genre.rnb => FontAwesomeIcons.music,
      Genre.country => FontAwesomeIcons.hatCowboy,
      Genre.edm => FontAwesomeIcons.headphones,
      Genre.jazz => FontAwesomeIcons.martiniGlassCitrus,
      Genre.latin => FontAwesomeIcons.guitar,
      Genre.classical => FontAwesomeIcons.keyboard,
      Genre.reggae => FontAwesomeIcons.drumSteelpan,
      Genre.blues => FontAwesomeIcons.music,
      Genre.soul => FontAwesomeIcons.music,
      Genre.funk => FontAwesomeIcons.guitar,
      Genre.metal => FontAwesomeIcons.guitar,
      Genre.punk => FontAwesomeIcons.guitar,
      Genre.indie => FontAwesomeIcons.guitar,
      Genre.folk => FontAwesomeIcons.guitar,
      Genre.alternative => FontAwesomeIcons.guitar,
      Genre.other => FontAwesomeIcons.music,
    };
  }
}
