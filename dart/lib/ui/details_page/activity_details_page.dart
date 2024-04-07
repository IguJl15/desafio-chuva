import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';

import '../../common/injection.dart';
import '../../common/page_future_builder.dart';
import '../../data/activity_repository.dart';
import '../../models/activity.dart';
import 'components/activity_information.dart';
import 'components/bookmark_button.dart';
import 'components/category_label.dart';
import 'components/speakers_list.dart';
import 'components/sub_activities_list.dart';

class ActivityDetailsPage extends StatelessWidget {
  static Widget activityPageBuilder(BuildContext context, int id) {
    return PageBuilder<int, Activity?>(
      key: const Key("activity-page-builder"),
      arg: id,
      future: (id) => getIt<ActivityRepository>().getActivityById(id),
      builder: (_, data) {
        if (data == null) {
          context.go("not-found");
          return Container();
        } else {
          return ActivityDetailsPage(activity: data);
        }
      },
    );
  }

  const ActivityDetailsPage({required this.activity, super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Chuva 💜 Flutter"),
        bottom: CategoryLabel(activity: activity),
      ),
      body: _Body(activity: activity),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.activity, super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const defaultVerticalPadding = EdgeInsets.symmetric(vertical: 32);

    return ListView(
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
        BookmarkButton(
          activity: activity,
        ),
        if (activity.description.value != null)
          Padding(
            padding: defaultVerticalPadding,
            child: HtmlWidget(
              activity.description.value!,
              textStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        if (activity.subActivities.isNotEmpty)
          Padding(
            padding: defaultVerticalPadding,
            child: SubActivities(activity: activity),
          ),
        if (activity.people.isNotEmpty)
          SpeakersList(
            activity: activity,
            people: activity.people,
          ),
      ],
    );
  }
}
