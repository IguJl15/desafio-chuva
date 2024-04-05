import 'package:chuva_dart/models/activity.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    final type = activity.type.title.value;
    final startTime = TimeOfDay.fromDateTime(activity.start);
    final endTime = TimeOfDay.fromDateTime(activity.end);

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Text("$type de $startTime até $endTime"),
            Text(activity.title.value),
            Text(activity.people.join(", ")),
          ],
        ),
      ),
    );
  }
}
