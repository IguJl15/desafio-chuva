import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';

import '../../common/injection.dart';
import '../../common/page_future_builder.dart';
import '../../data/activity_repository.dart';
import '../../models/activity.dart';
import 'components/person_activities.dart';
import 'components/person_info.dart';

class PersonPage extends StatelessWidget {
  static Widget personPageBuilder(BuildContext context, int id) {
    return PageBuilder<int, Pessoa?>(
      key: const Key("person-page-builder"),
      arg: id,
      future: (id) => getIt<ActivityRepository>().getPersonById(id),
      builder: (_, data) {
        if (data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go("not-found"));
          return Container();
        } else {
          return PersonPage(person: data);
        }
      },
    );
  }

  const PersonPage({required this.person, super.key});

  final Pessoa person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.titleMedium?.copyWith(height: 2);
    const defaultVerticalPadding = EdgeInsets.symmetric(vertical: 32);

    return Scaffold(
      appBar: AppBar(title: const Text('Chuva 💜 Flutter')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          PersonInfo(person: person),
          //
          if (person.bio?.value != null)
            Padding(
              padding: defaultVerticalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Biografia", style: labelStyle),
                  HtmlWidget(
                    person.bio!.value!,
                    textStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          //
          if (person.activities.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Atividades", style: labelStyle),
                PersonActivities(person: person),
              ],
            ),
        ],
      ),
    );
  }
}
