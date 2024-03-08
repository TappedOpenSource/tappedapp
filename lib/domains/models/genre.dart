import 'package:intheloopapp/utils/app_logger.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Genre {
  @JsonValue('afrobeat') afrobeat,
  @JsonValue('aggrotech') aggrotech,
  @JsonValue('ambient') ambient,
  @JsonValue('ambientPop') ambientPop,
  @JsonValue('americana') americana,
  @JsonValue('axé') axe,
  @JsonValue('bachata') bachata,
  @JsonValue('baião') baiao,
  @JsonValue('ballet') ballet,
  @JsonValue('blackenedCrust') blackenedCrust,
  @JsonValue('blues') blues,
  @JsonValue('bolero') bolero,
  @JsonValue('bossaNova') bossaNova,
  @JsonValue('bounce') bounce,
  @JsonValue('bregaCalypso') bregaCalypso,
  @JsonValue('britpop') britpop,
  @JsonValue('calypso') calypso,
  @JsonValue('chanson') chanson,
  @JsonValue('childrensMusic') childrensMusic,
  @JsonValue('christmas') christmas,
  @JsonValue('classical') classical,
  @JsonValue('classicalCrossover') classicalCrossover,
  @JsonValue('comedy') comedy,
  @JsonValue('country') country,
  @JsonValue('cumbia') cumbia,
  @JsonValue('dBeat') dBeat,
  @JsonValue('dance') dance,
  @JsonValue('dancehall') dancehall,
  @JsonValue('darkwave') darkwave,
  @JsonValue('deathIndustrial') deathIndustrial,
  @JsonValue('dembow') dembow,
  @JsonValue('driftPhonk') driftPhonk,
  @JsonValue('drone') drone,
  @JsonValue('dungeonSynth') dungeonSynth,
  @JsonValue('easyListening') easyListening,
  @JsonValue('electronic') electronic,
  @JsonValue('emo') emo,
  @JsonValue('epicCollage') epicCollage,
  @JsonValue('etherealWave') etherealWave,
  @JsonValue('exotica') exotica,
  @JsonValue('experimental') experimental,
  @JsonValue('fieldRecordings') fieldRecordings,
  @JsonValue('flamenco') flamenco,
  @JsonValue('flamencoPop') flamencoPop,
  @JsonValue('folk') folk,
  @JsonValue('forró') forro,
  @JsonValue('frevo') frevo,
  @JsonValue('funk') funk,
  @JsonValue('funkBrasileiro') funkBrasileiro,
  @JsonValue('futurepop') futurepop,
  @JsonValue('gamelan') gamelan,
  @JsonValue('glitchPop') glitchPop,
  @JsonValue('gospel') gospel,
  @JsonValue('gregorianChant') gregorianChant,
  @JsonValue('grunge') grunge,
  @JsonValue('hipHop') hipHop,
  @JsonValue('hymns') hymns,
  @JsonValue('hyperpop') hyperpop,
  @JsonValue('hypnagogicPop') hypnagogicPop,
  @JsonValue('indiePop') indiePop,
  @JsonValue('industrial') industrial,
  @JsonValue('janglePop') janglePop,
  @JsonValue('jazz') jazz,
  @JsonValue('juke') juke,
  @JsonValue('klezmer') klezmer,
  @JsonValue('latinAlternative') latinAlternative,
  @JsonValue('liquidDrumAndBass') liquidDrumAndBass,
  @JsonValue('mambo') mambo,
  @JsonValue('mandeMusic') mandeMusic,
  @JsonValue('maracatu') maracatu,
  @JsonValue('mariachi') mariachi,
  @JsonValue('mashup') mashup,
  @JsonValue('metal') metal,
  @JsonValue('minimalSynth') minimalSynth,
  @JsonValue('modaDeViola') modaDeViola,
  @JsonValue('mpb') mpb,
  @JsonValue('musicalParody') musicalParody,
  @JsonValue('musiqueConcrète') musiqueConcrete,
  @JsonValue('neoMedievalFolk') neoMedievalFolk,
  @JsonValue('neoclassicalDarkwave') neoclassicalDarkwave,
  @JsonValue('newAge') newAge,
  @JsonValue('newRave') newRave,
  @JsonValue('noise') noise,
  @JsonValue('noisePop') noisePop,
  @JsonValue('noisegrind') noisegrind,
  @JsonValue('nwobhm') nwobhm,
  @JsonValue('pianoRock') pianoRock,
  @JsonValue('plunderphonics') plunderphonics,
  @JsonValue('polka') polka,
  @JsonValue('pop') pop,
  @JsonValue('postHardcore') postHardcore,
  @JsonValue('postMinimalism') postMinimalism,
  @JsonValue('postPunk') postPunk,
  @JsonValue('powerElectronics') powerElectronics,
  @JsonValue('powerPop') powerPop,
  @JsonValue('progressivePop') progressivePop,
  @JsonValue('psichedeliaOccultaItaliana') psichedeliaOccultaItaliana,
  @JsonValue('psychedelia') psychedelia,
  @JsonValue('psychobilly') psychobilly,
  @JsonValue('punk') punk,
  @JsonValue('rAndB') rAndB,
  @JsonValue('radioDrama') radioDrama,
  @JsonValue('ragtime') ragtime,
  @JsonValue('rapRock') rapRock,
  @JsonValue('reggae') reggae,
  @JsonValue('reggaeton') reggaeton,
  @JsonValue('regional') regional,
  @JsonValue('rock') rock,
  @JsonValue('rockAndRoll') rockAndRoll,
  @JsonValue('rockabilly') rockabilly,
  @JsonValue('salsa') salsa,
  @JsonValue('samba') samba,
  @JsonValue('sampledelia') sampledelia,
  @JsonValue('seaShanties') seaShanties,
  @JsonValue('sertanejo') sertanejo,
  @JsonValue('sertanejoDeRaiz') sertanejoDeRaiz,
  @JsonValue('sertanejoUniversitário') sertanejoUniversitario,
  @JsonValue('showTunes') showTunes,
  @JsonValue('sierreño') sierreno,
  @JsonValue('singerSongwriter') singerSongwriter,
  @JsonValue('ska') ska,
  @JsonValue('spokenWord') spokenWord,
  @JsonValue('standards') standards,
  @JsonValue('surfPop') surfPop,
  @JsonValue('synthFunk') synthFunk,
  @JsonValue('synthPunk') synthPunk,
  @JsonValue('tango') tango,
  @JsonValue('tishoumaren') tishoumaren,
  @JsonValue('totalism') totalism,
  @JsonValue('tweePop') tweePop,
  @JsonValue('vanguardaPaulista') vanguardaPaulista,
  @JsonValue('vapor') vapor,
  @JsonValue('xote') xote,
  @JsonValue('yéYé') yeYe,
  @JsonValue('other') other,
}

Genre genreFromString(String genre) {
  final genres = Genre.values.map((e) => e.name).toList();
  final index = genres.indexOf(genre);
  if (index == -1) {
    return Genre.other;
  }

  return Genre.values[index];
}

List<Genre> fromStrings(List<String> strings) =>
    strings.map(genreFromString).toList();

extension GenreX on Genre {
  String get formattedName {
    return switch (this) {
      Genre.afrobeat => 'Afrobeat',
      Genre.aggrotech => 'Aggrotech',
      Genre.ambient => 'Ambient',
      Genre.ambientPop => 'Ambient Pop',
      Genre.americana => 'Americana',
      Genre.axe => 'Axé',
      Genre.bachata => 'Bachata',
      Genre.baiao => 'Baião',
      Genre.ballet => 'Ballet',
      Genre.blackenedCrust => 'Blackened Crust',
      Genre.blues => 'Blues',
      Genre.bolero => 'Bolero',
      Genre.bossaNova => 'Bossa Nova',
      Genre.bounce => 'Bounce',
      Genre.bregaCalypso => 'Brega Calypso',
      Genre.britpop => 'Britpop',
      Genre.calypso => 'Calypso',
      Genre.chanson => 'Chanson',
      Genre.childrensMusic => "Children's Music",
      Genre.christmas => 'Christmas',
      Genre.classical => 'Classical',
      Genre.classicalCrossover => 'Classical Crossover',
      Genre.comedy => 'Comedy',
      Genre.country => 'Country',
      Genre.cumbia => 'Cumbia',
      Genre.dBeat => 'D-Beat',
      Genre.dance => 'Dance',
      Genre.dancehall => 'Dancehall',
      Genre.darkwave => 'Darkwave',
      Genre.deathIndustrial => 'Death Industrial',
      Genre.dembow => 'Dembow',
      Genre.driftPhonk => 'Drift Phonk',
      Genre.drone => 'Drone',
      Genre.dungeonSynth => 'Dungeon Synth',
      Genre.easyListening => 'Easy Listening',
      Genre.electronic => 'Electronic',
      Genre.emo => 'Emo',
      Genre.epicCollage => 'Epic Collage',
      Genre.etherealWave => 'Ethereal Wave',
      Genre.exotica => 'Exotica',
      Genre.experimental => 'Experimental',
      Genre.fieldRecordings => 'Field Recordings',
      Genre.flamenco => 'Flamenco',
      Genre.flamencoPop => 'Flamenco Pop',
      Genre.folk => 'Folk',
      Genre.forro => 'Forró',
      Genre.frevo => 'Frevo',
      Genre.funk => 'Funk',
      Genre.funkBrasileiro => 'Funk Brasileiro',
      Genre.futurepop => 'Futurepop',
      Genre.gamelan => 'Gamelan',
      Genre.glitchPop => 'Glitch Pop',
      Genre.gospel => 'Gospel',
      Genre.gregorianChant => 'Gregorian Chant',
      Genre.grunge => 'Grunge',
      Genre.hipHop => 'Hip Hop',
      Genre.hymns => 'Hymns',
      Genre.hyperpop => 'Hyperpop',
      Genre.hypnagogicPop => 'Hypnagogic Pop',
      Genre.indiePop => 'Indie Pop',
      Genre.industrial => 'Industrial',
      Genre.janglePop => 'Jangle Pop',
      Genre.jazz => 'Jazz',
      Genre.juke => 'Juke',
      Genre.klezmer => 'Klezmer',
      Genre.latinAlternative => 'Latin Alternative',
      Genre.liquidDrumAndBass => 'Liquid Drum and Bass',
      Genre.mambo => 'Mambo',
      Genre.mandeMusic => 'Mande Music',
      Genre.maracatu => 'Maracatu',
      Genre.mariachi => 'Mariachi',
      Genre.mashup => 'Mashup',
      Genre.metal => 'Metal',
      Genre.minimalSynth => 'Minimal Synth',
      Genre.modaDeViola => 'Moda de Viola',
      Genre.mpb => 'MPB',
      Genre.musicalParody => 'Musical Parody',
      Genre.musiqueConcrete => 'Musique Concrète',
      Genre.neoMedievalFolk => 'Neo-Medieval Folk',
      Genre.neoclassicalDarkwave => 'Neoclassical Darkwave',
      Genre.newAge => 'New Age',
      Genre.newRave => 'New Rave',
      Genre.noise => 'Noise',
      Genre.noisePop => 'Noise Pop',
      Genre.noisegrind => 'Noisegrind',
      Genre.nwobhm => 'NWOBHM',
      Genre.pianoRock => 'Piano Rock',
      Genre.plunderphonics => 'Plunderphonics',
      Genre.polka => 'Polka',
      Genre.pop => 'Pop',
      Genre.postHardcore => 'Post-Hardcore',
      Genre.postMinimalism => 'Post-Minimalism',
      Genre.postPunk => 'Post-Punk',
      Genre.powerElectronics => 'Power Electronics',
      Genre.powerPop => 'Power Pop',
      Genre.progressivePop => 'Progressive Pop',
      Genre.psichedeliaOccultaItaliana => 'Psichedelia Occulta Italiana',
      Genre.psychedelia => 'Psychedelia',
      Genre.psychobilly => 'Psychobilly',
      Genre.punk => 'Punk',
      Genre.rAndB => 'R&B',
      Genre.radioDrama => 'Radio Drama',
      Genre.ragtime => 'Ragtime',
      Genre.rapRock => 'Rap Rock',
      Genre.reggae => 'Reggae',
      Genre.reggaeton => 'Reggaeton',
      Genre.regional => 'Regional',
      Genre.rock => 'Rock',
      Genre.rockAndRoll => 'Rock & Roll',
      Genre.rockabilly => 'Rockabilly',
      Genre.salsa => 'Salsa',
      Genre.samba => 'Samba',
      Genre.sampledelia => 'Sampledelia',
      Genre.seaShanties => 'Sea Shanties',
      Genre.sertanejo => 'Sertanejo',
      Genre.sertanejoDeRaiz => 'Sertanejo de Raiz',
      Genre.sertanejoUniversitario => 'Sertanejo Universitário',
      Genre.showTunes => 'Show Tunes',
      Genre.sierreno => 'Sierreño',
      Genre.singerSongwriter => 'Singer-Songwriter',
      Genre.ska => 'Ska',
      Genre.spokenWord => 'Spoken Word',
      Genre.standards => 'Standards',
      Genre.surfPop => 'Surf Pop',
      Genre.synthFunk => 'Synth Funk',
      Genre.synthPunk => 'Synth Punk',
      Genre.tango => 'Tango',
      Genre.tishoumaren => 'Tishoumaren',
      Genre.totalism => 'Totalism',
      Genre.tweePop => 'Twee Pop',
      Genre.vanguardaPaulista => 'Vanguarda Paulista',
      Genre.vapor => 'Vapor',
      Genre.xote => 'Xote',
      Genre.yeYe => 'Yé-yé',
      Genre.other => 'Other',
    };
  }
  //
  // List<String> get subgenres {
  //   return switch (this) {
  //
  //   };
  // }
}

// @JsonEnum()
// enum SubGenre {
//   Ambient,
//   Dub,
//   Noise,
//   Wall,
//   Dark,
//   Space,
//   Tribal,
//   Country,
//   Blues,
//   Electric,
//   Hindustani,
//   Classical,
//   Music,
//   Persian,
//   Western,
//   Comedy,
//   Rap,
//   Rock,
//   altCountry,
//   Bluegrass,
//   broCountry,
//   Contemporary,
//   Pop,
//   Soul,
//   Nashville,
//   Sound,
//   oldTime,
//   Outlaw,
//   Progressive,
//   Alternative,
//   Dance,
//   dancePop,
//   dancePunk,
//   Disco,
//   electronicDance,
//   Comfy,
//   Synth,
//   Lounge,
//   spaceAge,
//   Acid,
//   Jazz,
//   Bit,
//   Bitpop
//
//   Breakbeat
//   Chillout
//
//   Chillwave
//   Comfy
//
//   Synth
//   Dark
//
//   Ambient
//   Deconstructed
//
//   Club
//   Dub
//
//   Techno
//   Dubstep
//
//   Electro
//   Electro
//
//   -
//
//   Disco
//   Electro
//
//   -
//
//   Industrial
//   Electroacoustic
//
//   Electroclash
//   Electronic
//
//   Dance Music
//
//   Flashcore
//   Folktronica
//
//   Future Bass
//
//   Future Garage
//
//   Gabber
//   Glitch
//
//   Glitch Hop
//
//   Emo
//
//   -
//
//   Pop
//   Emocore
//
//   Midwest Emo
//
//   Screamo
//   Free
//
//   Improvisation
//   Hauntology
//
//   Indeterminacy
//   Microsound
//
//   Modern Creative
//
//   Reductionism
//   Sound
//
//   Art
//   Sound
//
//   Collage
//   Tape
//
//   Music
//   Turntable
//
//   Music
//   Nature
//
//   Recordings
//   Flamenco
//
//   Jazz
//   Flamenco
//
//   nuevo
//
//   Adult
//
//   Contemporary
//   Afrobeats
//
//   Alt
//
//   -
//
//   Pop
//   Art
//
//   Pop
//   Baroque
//
//   Pop
//   Boy
//
//   Band
//   Brill
//
//   Building
//   Bubblegum
//
//   Pop
//   C
//
//   -
//
//   Pop
//   City
//
//   Pop
//   Country
//
//   Pop
//   Dance
//
//   -
//
//   Pop
//   Denpa
//
//   Electropop
//   Europop
//
//   Folk Pop
//
//   French Pop
//
//   J
//
//   -
//
//   Pop
//   Jazz
//
//   Pop
//   K
//
//   -
//
//   Pop
//   Latin
//
//   Pop
//   Pop
//
//   Rock
//   Schlager
//
//   Shibuya
//
//   -
//
//   kei
//   Sophisti
//
//   -
//
//   Pop
// }
