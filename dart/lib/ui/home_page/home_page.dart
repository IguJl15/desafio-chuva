import 'dart:developer';

import 'package:chuva_dart/common/injection.dart';
import 'package:chuva_dart/models/activity.dart';
import 'package:chuva_dart/ui/cubits/activities_cubit.dart';
import 'package:chuva_dart/ui/home_page/components/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

                        final dates = state.activities.map(simplifiedDate).toSet().toList()
                          ..sort((a, b) => a.compareTo(b));

                        currentDateFilter ??= dates.firstOrNull;
                        if (!dates.contains(currentDateFilter)) {
                          currentDateFilter = dates.firstOrNull;
                        }

                        final MaterialLocalizations localizations =
                            MaterialLocalizations.of(context);
                        final month = currentDateFilter != null
                            ? localizations.formatShortMonthDay(currentDateFilter!).split(" ")[0]
                            : "";
                        final year = currentDateFilter != null
                            ? localizations.formatYear(currentDateFilter!)
                            : "";

                        return DefaultTabController(
                          initialIndex:
                              currentDateFilter != null ? dates.indexOf(currentDateFilter!) : 0,
                          length: dates.length,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "$month\n$year",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              Flexible(
                                child: TabBar(
                                  onTap: (index) => setState(() {
                                    log("foo");
                                    currentDateFilter = dates[index];
                                  }),
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  tabs: dates
                                      .map((e) => Tab(
                                            text: "${e.day}",
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
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
                      final date = currentDateFilter ?? simplifiedDate(activities.first);
                      final filteredActivities =
                          activities.where((act) => date == simplifiedDate(act));
                      return ListView(
                        children: List.generate(
                          filteredActivities.length,
                          (index) => ActivityCard(
                            filteredActivities.elementAt(index),
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

  DateTime simplifiedDate(Activity activity) =>
      DateTime(activity.start.year, activity.start.month, activity.start.day);

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
