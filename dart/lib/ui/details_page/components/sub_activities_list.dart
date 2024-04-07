import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/activity.dart';
import '../../home_page/components/activity_card.dart';

class SubActivities extends StatelessWidget {
  const SubActivities({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sub-atividades", style: Theme.of(context).textTheme.titleMedium),
        ...activity.subActivities.map((subAct) {
          return ActivityCard(
            subAct,
            onTap: (act) {
              context.push('/activity/${act.id}');
            },
          );
        }),
      ],
    );
  }
}
