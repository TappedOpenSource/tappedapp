import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';

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
    final database = context.database;
    final nav = context.nav;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
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
                              selectableResults = selectableResults.map((r) {
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
                      'found ${selectableResults.length} gig opportunities',
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
                    await EasyLoading.show(
                      status: 'applying to opportunities...',
                      maskType: EasyLoadingMaskType.black,
                    );
                    try {
                      for (final result in selectableResults) {
                        if (result.selected) {
                          await database.applyForOpportunity(
                              opportunity: result.op,
                              userId: currentUser.id,
                              userComment: '');
                        }
                      }
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
                  label: const Text('apply'),
                  icon: const Icon(Icons.check),
                )
              : null,
          body: ListView(
            children: selectableResults.map(
              (result) {
                final op = result.op;
                final startTime = DateFormat(
                  DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY,
                ).format(op.startTime);
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
                  leading: switch (op.flierUrl) {
                    None() => const Icon(Icons.image_not_supported),
                    Some(:final value) => CachedNetworkImage(
                        imageUrl: value,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                  },
                  title: Text(
                    op.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    startTime,
                  ),
                  trailing: Checkbox(
                    value: result.selected,
                    onChanged: (selected) {
                      setState(() {
                        selectableResults = selectableResults.map((r) {
                          return r.op.id == op.id
                              ? SelectableResult(
                                  op: r.op,
                                  selected: selected ?? false,
                                )
                              : r;
                        }).toList();
                      });
                    },
                  ),
                );
              },
            ).toList(),
          ),
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
