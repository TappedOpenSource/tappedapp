import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/graphic_designer/cubit/graphic_designer_cubit.dart';

class AvatarsPreview extends StatelessWidget {
  const AvatarsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphicDesignerCubit, GraphicDesignerState>(
      builder: (context, state) {
        if (state.avatars.isEmpty) {
          return const Center(
            child: Text('no avatars yet'),
          );
        }

        return GestureDetector(
          onTap: () {
            context.push(
              AvatarsGeneratedPage(
                imageUrls: state.avatars.map((e) => e.imageUrl).toList(),
              ),
            );
          },
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.avatars.length,
              itemBuilder: (context, index) {
                final avatar = state.avatars[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: CachedNetworkImage(
                    imageUrl: avatar.imageUrl,
                    width: 100,
                    height: 100,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
