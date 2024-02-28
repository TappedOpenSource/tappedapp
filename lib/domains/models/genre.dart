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
  @JsonValue('electronic')
  electronic,
  @JsonValue('dance')
  dance,
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
  @JsonValue('bluegrass')
  bluegrass,
  @JsonValue('gospel')
  gospel,
  @JsonValue('orchestra')
  orchestra,
  @JsonValue('theater')
  theater,
  @JsonValue('opera')
  opera,
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
      Genre.bluegrass => 'Bluegrass',
      Genre.edm => 'EDM',
      Genre.electronic => 'Electronic',
      Genre.dance => 'Dance',
      Genre.jazz => 'Jazz',
      Genre.latin => 'Latin',
      Genre.classical => 'Classical',
      Genre.gospel => 'Gospel',
      Genre.reggae => 'Reggae',
      Genre.blues => 'Blues',
      Genre.soul => 'Soul',
      Genre.funk => 'Funk',
      Genre.metal => 'Metal',
      Genre.punk => 'Punk',
      Genre.indie => 'Indie',
      Genre.folk => 'Folk',
      Genre.alternative => 'Alternative',
      Genre.opera => 'Opera',
      Genre.orchestra => 'Orchestra',
      Genre.theater => 'Theater',
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
      Genre.bluegrass => FontAwesomeIcons.hatCowboy,
      Genre.edm => FontAwesomeIcons.headphones,
      Genre.electronic => FontAwesomeIcons.headphones,
      Genre.dance => FontAwesomeIcons.headphones,
      Genre.jazz => FontAwesomeIcons.martiniGlassCitrus,
      Genre.latin => FontAwesomeIcons.guitar,
      Genre.classical => FontAwesomeIcons.keyboard,
      Genre.gospel => FontAwesomeIcons.music,
      Genre.reggae => FontAwesomeIcons.drumSteelpan,
      Genre.blues => FontAwesomeIcons.music,
      Genre.soul => FontAwesomeIcons.music,
      Genre.funk => FontAwesomeIcons.guitar,
      Genre.metal => FontAwesomeIcons.guitar,
      Genre.punk => FontAwesomeIcons.guitar,
      Genre.indie => FontAwesomeIcons.guitar,
      Genre.folk => FontAwesomeIcons.guitar,
      Genre.alternative => FontAwesomeIcons.guitar,
      Genre.opera => FontAwesomeIcons.music,
      Genre.orchestra => FontAwesomeIcons.music,
      Genre.theater => FontAwesomeIcons.music,
      Genre.other => FontAwesomeIcons.music,
    };
  }

  Color get color {
return switch (this) {
      Genre.pop => const Color(0xffFFD700),
      Genre.rock => const Color(0xffFF4500),
      Genre.hiphop => const Color(0xffFF69B4),
      Genre.rap => const Color(0xffFF69B4),
      Genre.rnb => const Color(0xffFF69B4),
      Genre.country => const Color(0xffFFD700),
      Genre.bluegrass => const Color(0xffFFD700),
      Genre.edm => const Color(0xffFF69B4),
      Genre.electronic => const Color(0xffFF69B4),
      Genre.dance => const Color(0xffFF69B4),
      Genre.jazz => const Color(0xffFFD700),
      Genre.latin => const Color(0xffFFD700),
      Genre.classical => const Color(0xffFFD700),
      Genre.gospel => const Color(0xffFFD700),
      Genre.reggae => const Color(0xffFFD700),
      Genre.blues => const Color(0xffFFD700),
      Genre.soul => const Color(0xffFFD700),
      Genre.funk => const Color(0xffFFD700),
      Genre.metal => const Color(0xffFFD700),
      Genre.punk => const Color(0xffFFD700),
      Genre.indie => const Color(0xffFFD700),
      Genre.folk => const Color(0xffFFD700),
      Genre.alternative => const Color(0xffFFD700),
      Genre.opera => const Color(0xffFFD700),
      Genre.orchestra => const Color(0xffFFD700),
      Genre.theater => const Color(0xffFFD700),
      Genre.other => const Color(0xffFFD700),
    };
  }
}
