import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/utils/admin_builder.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:skeletons/skeletons.dart';
import 'package:uuid/uuid.dart';

class OpportunityCard extends StatefulWidget {
  const OpportunityCard({
    required this.opportunity,
    this.onOpportunityDeleted,
    super.key,
  });

  final Opportunity opportunity;
  final void Function()? onOpportunityDeleted;

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  bool _isApplied = false;

  Opportunity get _opportunity => widget.opportunity;

  @override
  void initState() {
    super.initState();
    final state = context.onboarding.state;
    return switch (state) {
      Onboarded(:final currentUser) => (() {
          context.database
              .isUserAppliedForOpportunity(
            opportunityId: _opportunity.id,
            userId: currentUser.id,
          )
              .then((isApplied) {
            if (mounted) {
              setState(() {
                _isApplied = isApplied;
              });
            }
          });
        })(),
      _ => null,
    };
  }

  Widget _buildAppliedBadge(BuildContext context, {
    required Widget child,
  }) {
    final database = context.database;
    return badges.Badge(
      onTap: () => showDialog<AlertDialog>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
          title: const Text('are your sure?'),
          content:
          const Text('do you want to delete this opportunity'),
          actions: [
            TextButton(
              onPressed: () {
                database
                    .deleteOpportunity(widget.opportunity.id)
                    .then((value) {
                  widget.onOpportunityDeleted?.call();
                  Navigator.of(context, rootNavigator: true).pop();
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content: Text('error deleting opportunity'),
                    ),
                  );
                });
              },
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: Navigator.of(
                context,
                rootNavigator: true,
              ).pop,
              child: const Text('confirm'),
            ),
          ],
        ),
      ),
      position: badges.BadgePosition.custom(
        top: 0,
        end: 0,
      ),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.transparent,
      ),
      badgeContent: const Icon(
        CupertinoIcons.xmark_circle_fill,
        color: Colors.white,
        size: 25,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = context.places;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return AdminBuilder(
          builder: (context, isAdmin) {
            return ConditionalParentWidget(
              condition: _opportunity.userId == currentUser.id || isAdmin,
              conditionalBuilder: ({
                required Widget child,
              }) => Slidable(
                child: child,
              ),
              child: FutureBuilder(
                future: getOpImage(context, widget.opportunity),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ConditionalParentWidget(
                      condition: _isApplied,
                      conditionalBuilder: ({
                        required Widget child,
                      }) =>
                          child,
                      child: SkeletonListTile(),
                    );
                  }

                  final uuid = const Uuid().v4();
                  final heroImageTag =
                      'op-image-${widget.opportunity.id}-$uuid';
                  final heroTitleTag =
                      'op-title-${widget.opportunity.id}-$uuid';
                  final provider = snapshot.data!;
                  return ListTile(
                    onTap: () => showCupertinoModalBottomSheet<void>(
                    context: context,
                    builder: (context) => OpportunityView(
                      opportunityId: widget.opportunity.id,
                      opportunity: Option.of(widget.opportunity),
                      heroImage: HeroImage(
                        imageProvider: provider,
                        heroTag: heroImageTag,
                      ),
                      titleHeroTag: heroTitleTag,
                      onApply: () {
                        setState(() {
                          _isApplied = true;
                        });

                        Navigator.pop(context);
                      },
                      onDislike: () {
                        setState(() {
                          _isApplied = false;
                        });
                        context.pop();
                      },
                      onDismiss: () => context.pop(),
                    ),
                  ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(
                      widget.opportunity.title,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: FutureBuilder(
                      future: places.getPlaceById(
                        widget.opportunity.location.placeId,
                      ),
                      builder: (context, snapshot) {
                        final place = snapshot.data;
                        return switch (place) {
                          null => const SkeletonLine(),
                          None() => const SizedBox.shrink(),
                          Some(:final value) => Text(
                              formattedShortAddress(
                                value.addressComponents,
                              ).toLowerCase(),
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                              ),
                            ),
                        };
                      },
                    ),
                    trailing: _isApplied
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'applied' ,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : Text(
                      DateFormat(
                        'MM/dd',
                      ).format(
                        widget.opportunity.startTime,
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
