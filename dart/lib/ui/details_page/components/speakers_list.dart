import 'package:flutter/material.dart';

import '../../../models/activity.dart';

class SpeakersList extends StatelessWidget {
  const SpeakersList({
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
