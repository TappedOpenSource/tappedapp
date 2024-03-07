import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/utils/hero_image.dart';


class UploadFlierField extends StatelessWidget {
  const UploadFlierField({super.key});

  Widget _buildUploadButton(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        context.read<AddPastBookingCubit>().handleImageFromGallery();
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.upload_file,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Upload Flier/Poster (optional)',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return switch (state.flierFile) {
          None() => _buildUploadButton(context),
          Some(:final value) => badges.Badge(
            onTap: () => context.read<AddPastBookingCubit>().removeFlier(),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Color.fromARGB(255, 47, 47, 47),
            ),
            badgeContent: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 25,
            ),
            child: GestureDetector(
                onTap: () => context.push(
                  ImagePage(
                    heroImage: HeroImage(
                      heroTag: 'flier',
                      imageProvider: FileImage(value),
                    ),
                  ),
                ),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: FileImage(value),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ),
        };
      },
    );
  }
}
