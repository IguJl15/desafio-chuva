import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/activity.dart';

class SpeakersList extends StatelessWidget {
  const SpeakersList({
    super.key,
    required this.activity,
    required this.people,
  });

  final Activity activity;
  final List<Pessoa> people;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Group speakers by role
        Text("Palestrantes", style: Theme.of(context).textTheme.titleMedium),
        ...people.map((person) {
          return ListTile(
            onTap: () => context.goNamed("person-details", pathParameters: {
              "id": activity.id.toString(),
              "personId": person.id.toString(),
            }),
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
