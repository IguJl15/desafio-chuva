import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/utils.dart';
import '../cubits/activities_cubit.dart';
import 'components/activity_card.dart';
import 'components/dates_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? currentDateFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF456187),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          children: [
            Text("Chuva 💜 Flutter"),
            Text(
              "Programação",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: BlocBuilder<ActivitiesCubit, ActivitiesListState>(
              buildWhen: stateShouldRebuildUi,
              builder: (context, state) {
                if (state is! ActivitiesListSuccess) {
                  return Container();
                }

                final dates = state.activities.map((act) => simplifiedDateTime(act.start)).toList();

                currentDateFilter ??= dates.firstOrNull;
                if (!dates.contains(currentDateFilter)) {
                  currentDateFilter = dates.firstOrNull;
                }

                return DatesTabBar(
                  dates: dates,
                  selectedDate: currentDateFilter ?? DateTime.now(),
                  onDateSelect: (date) {
                    setState(() {
                      currentDateFilter = date;
                    });
                  },
                );
              }),
        ),
      ),
      body: BlocConsumer<ActivitiesCubit, ActivitiesListState>(
        listener: _cubitListener,
        buildWhen: stateShouldRebuildUi,
        builder: (context, state) {
          switch (state) {
            case ActivitiesListSuccess(:final activities):
              if (activities.isEmpty) {
                return const Center(child: Text("Sem atividades"));
              }

              final date = currentDateFilter ?? simplifiedDateTime(activities.first.start);
              final filteredActivities =
                  activities.where((act) => date == simplifiedDateTime(act.start));

              return RefreshIndicator.adaptive(
                onRefresh: () async => context.read<ActivitiesCubit>().fetchActivitiesFromPage(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  children: List.generate(
                    filteredActivities.length,
                    (index) => ActivityCard(
                      filteredActivities.elementAt(index),
                      onTap: (act) {
                        context.go('/activity/${act.id}');
                      },
                    ),
                  ),
                ),
              );
            case ActivitiesListLoading():
            case ActivitiesListInitialState():
              return const Center(child: CircularProgressIndicator.adaptive());
            case ActivitiesListError():
              throw AssertionError(
                "UI should not be updated when the state is ActivitiesListError",
              );
          }
        },
      ),
    );
  }

  bool stateShouldRebuildUi(_, state) =>
      state is ActivitiesListSuccess || state is ActivitiesListLoading;

  void _cubitListener(BuildContext context, ActivitiesListState state) {
    switch (state) {
      case ActivitiesListError(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      case ActivitiesListInitialState():
      case ActivitiesListLoading():
      case ActivitiesListSuccess():
        break;
    }
  }
}
