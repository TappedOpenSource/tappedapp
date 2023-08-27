import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

part 'social_media_manager_state.dart';

class SocialMediaManagerCubit extends Cubit<SocialMediaManagerState> {
  SocialMediaManagerCubit({
    required this.currentUser,
    required this.onboardingBloc,
  }) : super(SocialMediaManagerState(
    credits: currentUser.aiCredits,
  ));

  final UserModel currentUser;
  final OnboardingBloc onboardingBloc;

  int _getRandomIndex() {
    final random = Random();
    return random.nextInt(postIdeas.length);
  }

  void generatePostIdea() {
    final randomIndex = _getRandomIndex();
    final postIdea = postIdeas[randomIndex];
    final updatedCredits = state.credits - 1;

    final updated = currentUser.copyWith(
      aiCredits: updatedCredits,
    );
    onboardingBloc.add(UpdateOnboardedUser(user: updated));

    emit(
      state.copyWith(
        credits: updatedCredits,
        postIdea: Some(postIdea),
      ),
    );
  }
}

final postIdeas = [
  'Behind-the-scenes studio footage',
  'Sneak peeks of upcoming tracks',
  'Live streaming jam sessions',
  'Acoustic versions of popular songs',
  'Q&A sessions with fans',
  "Daily vlogs showcasing the artist's life",
  'Collaborative songwriting sessions',
  'Cover songs of favorite tracks',
  'Music gear and instrument tutorials',
  'Music production process breakdowns',
  'Song lyric explanations',
  'Challenges or dares from fans',
  'Virtual open mic sessions',
  'Unboxing of new musical equipment',
  'Throwback posts of early performances',
  'Fan art and creations showcase',
  'Sharing personal stories behind songs',
  'DIY music video creation tips',
  "Artist's favorite playlists and songs",
  'Shoutouts to fellow musicians',
  'Interactive polls for song choices',
  'Exclusive previews for Patreon supporters',
  '"Ask me anything" sessions',
  'Live covers of fan-favorite songs',
  'Collaborations with other artists',
  'Virtual meet-and-greets',
  'Day-in-the-life videos',
  'Inspirational quotes and messages',
  'Mini-lessons on music theory',
  'Songwriting challenges and prompts',
  'Recreating famous album covers',
  'Recording process walkthroughs',
  'Sharing personal musical influences',
  'Updates on upcoming live shows',
  'Progress updates on new albums',
  'Fan appreciation posts',
  'Photo shoots and behind-the-scenes looks',
  'Sharing favorite books, movies, or hobbies',
  'Guest appearances by other artists',
  'Fan-generated content highlights',
  'Live tutorials on playing specific songs',
  'Weekly music recommendations',
  'Collaborative cover projects with fans',
  'Sharing personal milestones and achievements',
  "Sharing the story behind the artist's name",
  'Bloopers and funny outtakes',
  '"A day in the studio" vlogs',
  "Artist's favorite inspirational quotes",
  'Creative music video concepts',
  'In-depth analyses of famous songs',
  'Memes related to music and artistry',
  'Instrument-specific tutorials',
  'Tips for overcoming creative blocks',
  'Interactive songwriting sessions',
  '"On this day" musical history posts',
  'Monthly challenges for fans to participate in',
  'Unfiltered thoughts on music industry trends',
  'Musical instrument reviews and recommendations',
  'Personal anecdotes from tours or shows',
  '"Top 10" lists related to music',
  'Sharing favorite local spots and hangouts',
  'Reacting to fan covers of their songs',
  'Stories behind stage outfits or costumes',
  'Collaborative art and music projects',
  'Sharing fan letters and messages',
  'Teasers for upcoming music videos',
  'Virtual song release parties',
  'Favorite songs to listen to while on the road',
  'Musical DIY projects and crafts',
  'Sharing the evolution of a song from demo to final version',
  'Tips for building a home recording setup',
  'Fan-submitted questions answered in videos',
  'Throwback photos from early musical days',
  'Daily or weekly challenges for fans',
  'Showcasing fan reactions to new music',
  'Expressing thoughts on music-related news',
  'Music-related book and documentary recommendations',
  'Collaborative lyric-writing sessions',
  'Live tutorials on playing specific instruments',
  'Celebrating milestones like album anniversaries',
  'In-depth analysis of music videos',
  'Sharing the story behind stage names or pseudonyms',
  'Discussing the process of choosing album artwork',
  'Exploring different music genres and styles',
  'Tips for managing stage fright and performance anxiety',
  'Live studio performances',
  'Virtual "open mic" nights for fans',
  'Sharing the story of how the artist started in music',
  "Exploring the artist's journey of finding their musical style",
  'Documentary-style videos on the making of an album',
  'Songwriting prompts for fans to participate in',
  'Live stream of the artist practicing new songs',
  'Covering songs from different eras or genres',
  'Collaborative fan art projects',
  'Personal anecdotes from tours or shows',
  'Sharing insights on the creative process',
  '"A day in the life" of the artist on tour',
  'Song remix competitions for fans',
  'Weekly music trivia quizzes',
  "Insights into the artist's daily routines and habits",
];
