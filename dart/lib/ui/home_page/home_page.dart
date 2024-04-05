import 'package:chuva_dart/common/injection.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivitiesCubit(getIt())..fetchActivitiesFromPage(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Column(
            children: [
              Text("Chuva 💜 Flutter"),
              Text("Programação"),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () => context.read<ActivitiesCubit>().fetchActivitiesFromPage(),
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: BlocConsumer<ActivitiesCubit, ActivitiesListState>(
          listener: _cubitListener,
          buildWhen: (_, state) => state is ActivitiesListSuccess || state is ActivitiesListLoading,
          builder: (context, state) {
            switch (state) {
              case ActivitiesListSuccess(:final activities):
                return ListView(
                  children: List.generate(
                    activities.length,
                    (index) => ActivityCard(
                      activities[index],
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
  }

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
