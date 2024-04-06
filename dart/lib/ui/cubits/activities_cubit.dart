import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_exception.dart';
import '../../data/activity_repository.dart';
import '../../models/activity.dart';

class ActivitiesCubit extends Cubit<ActivitiesListState> {
  ActivitiesCubit(this._repository) : super(ActivitiesListInitialState());

  final ActivityRepository _repository;

  void fetchActivitiesFromPage({page = 1}) async {
    final previousState = state;

    emit(ActivitiesListLoading());

    await Future.delayed(const Duration(milliseconds: 700));

    try {
      final activities = await _repository.fetchActivities(page);

      emit(ActivitiesListSuccess(activities: activities.toList()));
    } on AppError catch (e) {
      emit(ActivitiesListError(e));
      emit(previousState);
    }
  }
}

sealed class ActivitiesListState {}

class ActivitiesListInitialState extends ActivitiesListState {}

class ActivitiesListLoading extends ActivitiesListState {}

class ActivitiesListSuccess extends ActivitiesListState {
  final List<Activity> activities;

  ActivitiesListSuccess({required this.activities});
}

/// Emitted when a error occurs. Should not be used to update the UI,
/// only listened to display the error message
class ActivitiesListError extends ActivitiesListState {
  final AppError error;

  ActivitiesListError(this.error);
}
