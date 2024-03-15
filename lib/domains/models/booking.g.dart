// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      requesteeId: json['requesteeId'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      startTime:
          const DateTimeConverter().fromJson(json['startTime'] as Timestamp),
      endTime: const DateTimeConverter().fromJson(json['endTime'] as Timestamp),
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      requesterId: json['requesterId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['requesterId'], (value) => value as String),
      name: json['name'] == null
          ? const None()
          : Option<String>.fromJson(json['name'], (value) => value as String),
      note: json['note'] as String? ?? '',
      rate: json['rate'] as int? ?? 0,
      serviceId: json['serviceId'] == null
          ? const None()
          : Option<String>.fromJson(
              json['serviceId'], (value) => value as String),
      addedByUser: json['addedByUser'] as bool? ?? false,
      flierUrl: json['flierUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['flierUrl'], (value) => value as String),
      ticketUrl: json['ticketUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['ticketUrl'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GenreEnumMap, e))
              .toList() ??
          const [],
      location: json['location'] == null
          ? const None()
          : Option<Location>.fromJson(json['location'],
              (value) => Location.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesteeId': instance.requesteeId,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'requesterId': instance.requesterId.toJson(
        (value) => value,
      ),
      'name': instance.name.toJson(
        (value) => value,
      ),
      'note': instance.note,
      'rate': instance.rate,
      'serviceId': instance.serviceId.toJson(
        (value) => value,
      ),
      'addedByUser': instance.addedByUser,
      'flierUrl': instance.flierUrl.toJson(
        (value) => value,
      ),
      'ticketUrl': instance.ticketUrl.toJson(
        (value) => value,
      ),
      'genres': instance.genres.map((e) => _$GenreEnumMap[e]!).toList(),
      'location': instance.location.toJson(
        (value) => value,
      ),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.canceled: 'canceled',
};

const _$GenreEnumMap = {
  Genre.pop: 'pop',
  Genre.hipHop: 'hipHop',
  Genre.electronic: 'electronic',
  Genre.rAndB: 'rAndB',
  Genre.rock: 'rock',
  Genre.metal: 'metal',
  Genre.funk: 'funk',
  Genre.jazz: 'jazz',
  Genre.punk: 'punk',
  Genre.psychedelia: 'psychedelia',
  Genre.afrobeat: 'afrobeat',
  Genre.aggrotech: 'aggrotech',
  Genre.ambient: 'ambient',
  Genre.ambientPop: 'ambientPop',
  Genre.americana: 'americana',
  Genre.axe: 'axé',
  Genre.bachata: 'bachata',
  Genre.baiao: 'baião',
  Genre.ballet: 'ballet',
  Genre.blackenedCrust: 'blackenedCrust',
  Genre.blues: 'blues',
  Genre.bolero: 'bolero',
  Genre.bossaNova: 'bossaNova',
  Genre.bounce: 'bounce',
  Genre.bregaCalypso: 'bregaCalypso',
  Genre.britpop: 'britpop',
  Genre.calypso: 'calypso',
  Genre.chanson: 'chanson',
  Genre.childrensMusic: 'childrensMusic',
  Genre.christmas: 'christmas',
  Genre.classical: 'classical',
  Genre.classicalCrossover: 'classicalCrossover',
  Genre.comedy: 'comedy',
  Genre.country: 'country',
  Genre.cumbia: 'cumbia',
  Genre.dBeat: 'dBeat',
  Genre.dance: 'dance',
  Genre.dancehall: 'dancehall',
  Genre.darkwave: 'darkwave',
  Genre.deathIndustrial: 'deathIndustrial',
  Genre.dembow: 'dembow',
  Genre.driftPhonk: 'driftPhonk',
  Genre.drone: 'drone',
  Genre.dungeonSynth: 'dungeonSynth',
  Genre.easyListening: 'easyListening',
  Genre.emo: 'emo',
  Genre.epicCollage: 'epicCollage',
  Genre.etherealWave: 'etherealWave',
  Genre.exotica: 'exotica',
  Genre.experimental: 'experimental',
  Genre.fieldRecordings: 'fieldRecordings',
  Genre.flamenco: 'flamenco',
  Genre.flamencoPop: 'flamencoPop',
  Genre.folk: 'folk',
  Genre.forro: 'forró',
  Genre.frevo: 'frevo',
  Genre.funkBrasileiro: 'funkBrasileiro',
  Genre.futurepop: 'futurepop',
  Genre.gamelan: 'gamelan',
  Genre.glitchPop: 'glitchPop',
  Genre.gospel: 'gospel',
  Genre.gregorianChant: 'gregorianChant',
  Genre.grunge: 'grunge',
  Genre.hymns: 'hymns',
  Genre.hyperpop: 'hyperpop',
  Genre.hypnagogicPop: 'hypnagogicPop',
  Genre.indiePop: 'indiePop',
  Genre.industrial: 'industrial',
  Genre.janglePop: 'janglePop',
  Genre.juke: 'juke',
  Genre.klezmer: 'klezmer',
  Genre.latinAlternative: 'latinAlternative',
  Genre.liquidDrumAndBass: 'liquidDrumAndBass',
  Genre.mambo: 'mambo',
  Genre.mandeMusic: 'mandeMusic',
  Genre.maracatu: 'maracatu',
  Genre.mariachi: 'mariachi',
  Genre.mashup: 'mashup',
  Genre.minimalSynth: 'minimalSynth',
  Genre.modaDeViola: 'modaDeViola',
  Genre.mpb: 'mpb',
  Genre.musicalParody: 'musicalParody',
  Genre.musiqueConcrete: 'musiqueConcrète',
  Genre.neoMedievalFolk: 'neoMedievalFolk',
  Genre.neoclassicalDarkwave: 'neoclassicalDarkwave',
  Genre.newAge: 'newAge',
  Genre.newRave: 'newRave',
  Genre.noise: 'noise',
  Genre.noisePop: 'noisePop',
  Genre.noisegrind: 'noisegrind',
  Genre.nwobhm: 'nwobhm',
  Genre.pianoRock: 'pianoRock',
  Genre.plunderphonics: 'plunderphonics',
  Genre.polka: 'polka',
  Genre.postHardcore: 'postHardcore',
  Genre.postMinimalism: 'postMinimalism',
  Genre.postPunk: 'postPunk',
  Genre.powerElectronics: 'powerElectronics',
  Genre.powerPop: 'powerPop',
  Genre.progressivePop: 'progressivePop',
  Genre.psichedeliaOccultaItaliana: 'psichedeliaOccultaItaliana',
  Genre.psychobilly: 'psychobilly',
  Genre.radioDrama: 'radioDrama',
  Genre.ragtime: 'ragtime',
  Genre.rapRock: 'rapRock',
  Genre.reggae: 'reggae',
  Genre.reggaeton: 'reggaeton',
  Genre.regional: 'regional',
  Genre.rockAndRoll: 'rockAndRoll',
  Genre.rockabilly: 'rockabilly',
  Genre.salsa: 'salsa',
  Genre.samba: 'samba',
  Genre.sampledelia: 'sampledelia',
  Genre.seaShanties: 'seaShanties',
  Genre.sertanejo: 'sertanejo',
  Genre.sertanejoDeRaiz: 'sertanejoDeRaiz',
  Genre.sertanejoUniversitario: 'sertanejoUniversitário',
  Genre.showTunes: 'showTunes',
  Genre.sierreno: 'sierreño',
  Genre.singerSongwriter: 'singerSongwriter',
  Genre.ska: 'ska',
  Genre.spokenWord: 'spokenWord',
  Genre.standards: 'standards',
  Genre.surfPop: 'surfPop',
  Genre.synthFunk: 'synthFunk',
  Genre.synthPunk: 'synthPunk',
  Genre.tango: 'tango',
  Genre.tishoumaren: 'tishoumaren',
  Genre.totalism: 'totalism',
  Genre.tweePop: 'tweePop',
  Genre.vanguardaPaulista: 'vanguardaPaulista',
  Genre.vapor: 'vapor',
  Genre.xote: 'xote',
  Genre.yeYe: 'yéYé',
  Genre.other: 'other',
};
