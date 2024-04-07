import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/bookmark_cubit.dart';

class BookmarkBuilder extends StatelessWidget {
  const BookmarkBuilder({
    required this.activityId,
    required this.unmarkedWidget,
    required this.loadingWidget,
    required this.markedWidget,
    super.key,
  });

  final int activityId;
  final Widget? unmarkedWidget;
  final Widget? loadingWidget;
  final Widget? markedWidget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (_, state) {
        bool isLoading = false;
        bool marked = false;

        switch (state) {
          case BookmarkInitialState():
            break;
          case BookmarkLoadingState():
            if (!isLoading) {
              isLoading = true;
            }
            break;
          case BookmarkErrorState(:final error):
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));

            isLoading = false;
            break;
          case BookmarkSuccessState(:final bookmarkedActivities):
            isLoading = false;
            marked = bookmarkedActivities.contains(activityId);
            break;
        }

        return (isLoading
                ? loadingWidget
                : marked
                    ? markedWidget
                    : unmarkedWidget) ??
            Container();
      },
    );
  }
}
