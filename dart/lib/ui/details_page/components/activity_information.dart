import 'package:flutter/material.dart';

import '../../../common/utils.dart';
import '../../../models/activity.dart';

class ActivityInformation extends StatelessWidget {
  const ActivityInformation({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final weekDay = weekdays[activity.start.weekday - DateTime.monday];
    final startTime = TimeOfDay.fromDateTime(activity.start);
    final endTime = TimeOfDay.fromDateTime(activity.end);

    const iconSize = 20.0;
    const xSmallSpace = SizedBox.square(dimension: 4);
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.schedule, size: iconSize),
            xSmallSpace,
            Text("$weekDay ${startTime.format(context)} - ${endTime.format(context)}")
          ],
        ),
        xSmallSpace,
        if (activity.locations.first.title.value != null)
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: iconSize),
              xSmallSpace,
              Text(activity.locations.first.title.value!),
            ],
          ),
      ],
    );
  }
}
