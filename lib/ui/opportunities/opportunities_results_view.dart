import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quiver/iterables.dart';
import 'package:skeletons/skeletons.dart';

class OpportunitiesResultsView extends StatefulWidget {
  const OpportunitiesResultsView({
    required this.ops,
    super.key,
  });

  final List<Opportunity> ops;

  @override
  State<OpportunitiesResultsView> createState() =>
      _OpportunitiesResultsViewState();
}

class _OpportunitiesResultsViewState extends State<OpportunitiesResultsView> {
  List<SelectableResult> selectableResults = [];

  bool get allSelected => selectableResults.every((result) => result.selected);

  bool get anySelected => selectableResults.any((result) => result.selected);

  @override
  void initState() {
    super.initState();
    selectableResults = widget.ops.map((op) {
      return SelectableResult(
        op: op,
        selected: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = context.nav;
    final opBloc = context.opportunities;
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return PremiumBuilder(
          builder: (context, isPremium) {
            return BlocBuilder<OpportunityBloc, OpportunityState>(
              builder: (context, state) {
                final hasEnoughQuota = isPremium ||
                    state.opQuota >=
                        selectableResults
                            .where(
                              (result) => result.selected,
                        )
                            .length;
                return Scaffold(
                  backgroundColor: theme.colorScheme.surface,
                  appBar: AppBar(
                    leading: const SizedBox.shrink(),
                    actions: const [],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: allSelected,
                                  onChanged: (selected) {
                                    setState(() {
                                      selectableResults =
                                          selectableResults.map((r) {
                                            return SelectableResult(
                                              op: r.op,
                                              selected: selected ?? false,
                                            );
                                          }).toList();
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                const Text('select all'),
                              ],
                            ),
                            Text(
                              'found ${selectableResults
                                  .length} gig opportunities',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: anySelected
                      ? FloatingActionButton.extended(
                    onPressed: () async {
                      if (!hasEnoughQuota) {
                        context
                          ..pop()
                          ..push(
                            PaywallPage(),
                          );
                        return;
                      }

                      final isAppliedBatch = await Future.wait(
                        selectableResults
                            .where(
                              (result) => result.selected,
                        )
                            .map(
                              (result) =>
                              database.isUserAppliedForOpportunity(
                                opportunityId: result.op.id,
                                userId: currentUser.id,
                              ),
                        )
                            .toList(),
                      );

                      final zippedAppliedResults = zip([
                        selectableResults
                            .where(
                              (result) => result.selected,
                        )
                            .toList(),
                        isAppliedBatch,
                      ]);

                      final resultsToApply = zippedAppliedResults
                          .where(
                            (zipped) {
                          final result = zipped[0] as SelectableResult;
                          final isApplied = zipped[1] as bool;

                          return !isApplied && result.selected;
                        },
                      )
                          .map(
                            (zipped) => (zipped[0] as SelectableResult).op,)
                          .toList();

                      await EasyLoading.show(
                        status: 'applying to opportunities...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      try {
                        opBloc.add(
                          BatchApplyForOpportunities(
                            opportunities: resultsToApply,
                            userComment: '',
                          ),
                        );
                        nav.pop();
                      } catch (e, s) {
                        await EasyLoading.showError(e.toString());
                        logger.error(
                          'error applying to opportunities',
                          error: e,
                          stackTrace: s,
                        );
                      } finally {
                        await EasyLoading.dismiss();
                      }
                    },
                    backgroundColor: hasEnoughQuota
                        ? theme.colorScheme.primary
                        : Colors.grey.withOpacity(0.8),
                    label: hasEnoughQuota
                        ? const Text('apply')
                        : const Text('upgrade'),
                    icon: hasEnoughQuota
                        ? const Icon(Icons.check)
                        : const Icon(Icons.lock),
                  )
                      : null,
                  body: ListView(
                    children: selectableResults.map(
                          (result) {
                        final op = result.op;
                        final startTime = DateFormat(
                          DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY,
                        ).format(op.startTime);
                        return FutureBuilder(
                          future: getOpImage(context, op),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SkeletonListTile();
                            }

                            final provider = snapshot.data!;
                            return FutureBuilder(
                              future: database.isUserAppliedForOpportunity(
                                opportunityId: op.id,
                                userId: currentUser.id,
                              ),
                              builder: (context, snapshot) {
                                final isApplied = snapshot.data;
                                return ListTile(
                                  onTap: () {
                                    showCupertinoModalBottomSheet<void>(
                                      context: context,
                                      builder: (context) {
                                        return OpportunityView(
                                          opportunityId: op.id,
                                          opportunity: Option.of(op),
                                          onDislike: () {
                                            context.pop();
                                          },
                                        );
                                      },
                                    );
                                  },
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
                                    op.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    startTime,
                                  ),
                                  trailing: switch (isApplied) {
                                    null => CupertinoActivityIndicator(),
                                    false =>
                                        Checkbox(
                                          value: result.selected,
                                          onChanged: (selected) {
                                            setState(() {
                                              selectableResults =
                                                  selectableResults.map((r) {
                                                    return r.op.id == op.id
                                                        ? SelectableResult(
                                                      op: r.op,
                                                      selected:
                                                      selected ?? false,
                                                    )
                                                        : r;
                                                  }).toList();
                                            });
                                          },
                                        ),
                                    true =>
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'applied',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SelectableResult {
  const SelectableResult({
    required this.op,
    required this.selected,
  });

  final Opportunity op;
  final bool selected;
}
