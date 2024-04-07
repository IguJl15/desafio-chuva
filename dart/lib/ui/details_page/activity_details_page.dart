import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_exception.dart';
import '../../common/injection.dart';
import '../../data/activity_repository.dart';
import '../../models/activity.dart';
import 'components/activity_information.dart';
import 'components/category_label.dart';
import 'components/speakers_list.dart';
import 'components/sub_activities_list.dart';

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({required this.activityId, super.key});

  final int activityId;

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late final Activity activity;
  String error = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final repository = getIt<ActivityRepository>();

        final act = await repository.getActivityById(widget.activityId);

        if (act == null) {
          if (mounted) context.goNamed("not-found");
          return;
        }

        activity = act;
        isLoading = false;
        error = "";
      } on AppError catch (e) {
        error = e.message;
        isLoading = false;
      } catch (e) {
        log("Error: ", error: e);

        error = "Ocorreu um erro desconhecido";
        isLoading = false;
      } finally {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = !(isLoading || error.isNotEmpty);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Chuva 💜 Flutter"),
        bottom: ready ? CategoryLabel(activity: activity) : null,
      ),
      body: ready
          ? _Body(activity: activity)
          : (isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : error.isNotEmpty
                  ? Center(child: Text(error))
                  : null),
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

        if (activity.people.isNotEmpty) SpeakersList(people: activity.people),
      ],
    );
  }
}
