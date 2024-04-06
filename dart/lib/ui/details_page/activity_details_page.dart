import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../common/utils.dart';
import '../../models/activity.dart';
import '../home_page/components/activity_card.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage(this.activity, {super.key});

  final Activity activity;

  Color _foregroundColorFor(
    Color backgroundColor, [
    darkColor = Colors.black,
    lightColor = Colors.white,
  ]) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light
        ? darkColor
        : lightColor;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final theme = Theme.of(context);

    final categoryColor = activity.category.color != null
        ? Color(colorCodeFromCss(activity.category.color!))
        : Colors.black;

    Color textColor = _foregroundColorFor(categoryColor);

    const defaultVerticalPadding = EdgeInsets.symmetric(vertical: 32);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Chuva 💜 Flutter"),
        bottom: activity.category.title.value == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Container(
                  color: categoryColor,
                  child: Center(
                    child: Text(
                      activity.category.title.value!,
                      style: theme.textTheme.bodySmall?.copyWith(color: textColor, height: 1.75),
                    ),
                  ),
                ),
              ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            activity.title.value ?? Activity.emptyTitleWarning,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),

          Padding(
            padding: defaultVerticalPadding / 2,
            child: ActivityInformation(activity: activity),
          ),

          // TODO: Implement bookmarking
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.star),
            label: const Text("Adicionar à sua agenda"),
          ),

          if (activity.description.value != null)
            Padding(
              padding: defaultVerticalPadding,
              child: HtmlWidget(activity.description.value!),
            ),

          if (activity.subActivities.isNotEmpty)
            Padding(
              padding: defaultVerticalPadding,
              child: SubActivities(activity: activity),
            ),

          if (activity.people.isNotEmpty) Speakers(people: activity.people),
        ],
      ),
    );
  }
}

class Speakers extends StatelessWidget {
  const Speakers({
    super.key,
    required this.people,
  });

  final List<Pessoa> people;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Palestrantes", style: Theme.of(context).textTheme.titleMedium),
        ...people.map((person) {
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              foregroundImage: person.picture != null ? NetworkImage(person.picture!) : null,
              child: const Icon(Icons.person),
            ),
            title: Text(person.name.trim()),
            subtitle: Text(person.institution ?? " "),
          );
        }),
      ],
    );
  }
}

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
            onTap: (act) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivityDetailsPage(act)),
            ),
          );
        }),
      ],
    );
  }
}

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
