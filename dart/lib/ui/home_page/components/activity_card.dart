import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    final type = activity.type.title.value;
    final startTime = TimeOfDay.fromDateTime(activity.start);
    final endTime = TimeOfDay.fromDateTime(activity.end);

    final borderColorHex = 0xFF000000 | (int.tryParse(activity.category.color?.substring(1) ?? "", radix: 16) ?? 0);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // TODO: Check for sub activities
    return Card(
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(left: 8) + const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 4,
                style: BorderStyle.solid,
                color: Color(borderColorHex),
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
                  Icon(Icons.bookmark_rounded, color: colorScheme.tertiary)
                ],
              ),
              Text(activity.title.value, style: textTheme.bodyLarge),
              Text(
                activity.people.map((p) => p.name.trim()).join(", "),
                style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              if (kDebugMode && activity.parent != null) Text("Parent: ${activity.parent}", style: textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
