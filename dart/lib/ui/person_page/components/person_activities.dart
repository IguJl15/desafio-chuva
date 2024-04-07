import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common/utils.dart';
import '../../../models/activity.dart';
import '../../home_page/components/activity_card.dart';

class PersonActivities extends StatelessWidget {
  const PersonActivities({super.key, required this.person});

  final Pessoa person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);

    final activitiesGroupedByDate = person.activities.fold<Map<DateTime, List<Activity>>>(
      {},
      (map, activity) {
        return map
          ..putIfAbsent(
            simplifiedDateTime(activity.start),
            () => [],
          ).add(activity);
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activitiesGroupedByDate.entries.map((group) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              toBeginningOfSentenceCase(localizations.formatFullDate(group.key)) ?? "",
              style: theme.textTheme.titleSmall,
            ),
            ...group.value
                .map(
                  (e) => ActivityCard(
                    e,
                    onTap: (act) => context.push("/activity/${act.id}"),
                  ),
                )
                .toList()
          ],
        );
      }).toList(),
    );
  }
}
