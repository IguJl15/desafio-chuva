import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../common/utils.dart';
import '../../../models/activity.dart';
import '../../shared/bookmark_builder.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final Function(Activity) onTap;
  const ActivityCard(this.activity, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final card = _Card(activity: activity, onTap: () => onTap(activity));

    if (activity.subActivities.isEmpty) {
      return card;
    }

    const maxSubActivities = 2;

    final subActivitiesQtd = min(maxSubActivities, activity.subActivities.length);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        ...List.generate(
          subActivitiesQtd,
          (index) {
            final offset = (subActivitiesQtd - index) * 3.0;
            final scale = 1 - (subActivitiesQtd - index) * 0.008;

            return Container(
              margin: EdgeInsets.only(top: offset),
              child: Transform.scale(
                scaleX: scale,
                alignment: Alignment.topRight,
                child: _Card(activity: activity, onTap: null),
              ),
            );
          },
        ),
        card,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.activity, required this.onTap});

  final Activity activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final type = activity.type.title.value;
    final startTime = TimeOfDay.fromDateTime(activity.start.toLocal());
    final endTime = TimeOfDay.fromDateTime(activity.end.toLocal());

    final color = activity.category.color != null
        ? Color(colorCodeFromCss(activity.category.color!))
        : Colors.black;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 8) + const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 5,
                style: BorderStyle.solid,
                color: color,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "$type de ${startTime.format(context)} até ${endTime.format(context)}",
                      style: textTheme.labelMedium,
                    ),
                  ),
                  BookmarkBuilder(
                    activityId: activity.id,
                    unmarkedWidget: null,
                    loadingWidget: null,
                    markedWidget: Icon(Icons.bookmark_rounded, color: colorScheme.tertiary),
                  ),
                ],
              ),
              Text(
                activity.title.value ?? Activity.emptyTitleWarning,
                style: textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                activity.people.map((p) => p.name.trim()).join(", "),
                style:
                    textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              if (!kDebugMode && activity.parent != null)
                Text("Parent: ${activity.parent}", style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
