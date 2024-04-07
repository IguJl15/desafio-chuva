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

    //https://m3.material.io/components/buttons/specs#:~:text=with%20icon%20disabled-,icon%20opacity,-%2D
    final circularProgressIndicatorColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.38);

    return BookmarkBuilder(
      activityId: activity.id,
      unmarkedWidget: FilledButton.icon(
        onPressed: () => cubit.bookmark(activity),
        icon: const Icon(Icons.star_outline),
        label: const Text("Adicionar à sua agenda"),
      ),
      loadingWidget: FilledButton.icon(
        onPressed: null,
        icon: SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(
            color: circularProgressIndicatorColor,
            strokeWidth: 2,
          ),
        ),
        label: const Text("Processando"),
      ),
      markedWidget: FilledButton.icon(
        onPressed: () => cubit.removeBookmark(activity),
        icon: const Icon(Icons.star),
        label: const Text("Remover da sua agenda"),
      ),
    );
  }
}
