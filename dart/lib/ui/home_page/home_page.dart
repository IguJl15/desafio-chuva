import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/injection.dart';
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
    return BlocProvider(
      create: (_) => ActivitiesCubit(getIt())..fetchActivitiesFromPage(),
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                title: const Column(
                  children: [
                    Text("Chuva 💜 Flutter"),
                    Text("Programação"),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: BlocBuilder<ActivitiesCubit, ActivitiesListState>(
                      buildWhen: stateShouldRebuildUi,
                      builder: (context, state) {
                        if (state is! ActivitiesListSuccess) {
                          return Container();
                        }

                        final dates =
                            state.activities.map((act) => simplifiedDateTime(act.start)).toList();

                        currentDateFilter ??= dates.firstOrNull;
                        if (!dates.contains(currentDateFilter)) {
                          currentDateFilter = dates.firstOrNull;
                        }

                        return DatesTabBar(
                          dates: dates,
                          selectedDate: currentDateFilter ?? DateTime.now(),
                          onDateSelect: (date) => setState(() {
                            log("foo");
                            currentDateFilter = date;
                          }),
                        );
                      }),
                ),
                actions: [
                  IconButton(
                      onPressed: () => context.read<ActivitiesCubit>().fetchActivitiesFromPage(),
                      icon: const Icon(Icons.refresh))
                ],
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

                      return ListView(
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
            ),
          );
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
