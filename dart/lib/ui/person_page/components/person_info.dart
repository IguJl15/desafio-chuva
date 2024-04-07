import 'package:chuva_dart/models/activity.dart';
import 'package:flutter/material.dart';

class PersonInfo extends StatelessWidget {
  const PersonInfo({super.key, required this.person});

  final Pessoa person;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage: person.picture != null ? NetworkImage(person.picture!) : null,
          radius: 48,
          child: const Icon(Icons.person),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name.trim(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(person.institution?.trim() ?? "",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
