import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/activity.dart';
import '../../cubits/bookmark_cubit.dart';
import '../../shared/bookmark_builder.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({required this.activity, super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookmarkCubit>();
    return BookmarkBuilder(
      activityId: activity.id,
      unmarkedWidget: FilledButton.icon(
        onPressed: () => cubit.bookmark(activity),
        icon: const Icon(Icons.bookmark_outline),
        label: const Text("Adicionar à sua agenda"),
      ),
      loadingWidget: FilledButton.icon(
        onPressed: null,
        icon: const SizedBox.square(dimension: 16, child: CircularProgressIndicator.adaptive()),
        label: const Text("Processando"),
      ),
      markedWidget: FilledButton.icon(
        onPressed: () => cubit.removeBookmark(activity),
        icon: const Icon(Icons.bookmark_rounded),
        label: const Text("Remover da sua agenda"),
      ),
    );
  }
}
