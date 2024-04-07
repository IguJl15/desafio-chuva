import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../common/assets_manager.dart';
import '../models/activity.dart';

abstract interface class ActivityRepository {
  Future<Iterable<Activity>> fetchActivities([page = 1]);
  Future<Activity?> getActivityById(int id);

  Future<Pessoa?> getPersonById(int id);
}

@Singleton(as: ActivityRepository)
class MockedActivityRepository implements ActivityRepository {
  MockedActivityRepository(this.assetsManager);

  final AssetsManager assetsManager;

  late final Iterable<Map<String, dynamic>> _activitiesPages;

  /// resources: Assets location for the activities fixture json files that will be loaded and processed
  @PostConstruct(preResolve: true)
  Future<void> initialize({
    List<String> resources = const [
      "assets/activities.json",
      "assets/activities-1.json",
    ],
  }) async {
    final jsonFilesStrings = await Future.wait<String>(
      resources.map(
        (r) async {
          final foo = await assetsManager.loadString(r);

          return foo;
        },
      ),
    );

    _activitiesPages = jsonFilesStrings.map((e) => json.decode(e));
  }

  @override
  Future<Iterable<Activity>> fetchActivities([page = 1]) async {
    assert(page > 0);

    final data = _activitiesPages.elementAtOrNull(page - 1);

    if (data == null) return [];

    final List<dynamic> activitiesJsonList = data["data"];

    final activitiesList = activitiesJsonList.map((e) => Activity.fromJson(e)).toList();

    // TODO: ignore pagination concatenating activities
    // FIXME: only sub activities listed in this page are added to its parent activity
    //  Example:
    //  If a activity A has sub activities X and Y but Y is only listed in the next
    //  page, it will not be added to the sub activities list
    final subActivitiesList = [];

    for (final act in activitiesList) {
      if (act.parent == null) continue;

      final parent = activitiesList.where((element) => element.id == act.parent).singleOrNull;
      if (parent == null) continue;

      parent.subActivities.add(act);
      subActivitiesList.add(act);
    }

    activitiesList.removeWhere((e) => subActivitiesList.contains(e));

    return activitiesList;
  }

  @override
  Future<Activity?> getActivityById(int id) async {
    Activity? foundActivity;
    List<Activity> activitiesWithParent = [];

    for (var page in _activitiesPages) {
      for (var activityJson in page['data']) {
        final activity = Activity.fromJson(activityJson);
        if (activityJson['id'] == id) {
          foundActivity = activity;
        }
        if (activityJson['parent'] != null) {
          activitiesWithParent.add(activity);
        }
      }
    }

    return foundActivity
      ?..subActivities.addAll(
        activitiesWithParent.where((element) => element.parent == foundActivity?.id),
      );
  }

  @override
  Future<Pessoa?> getPersonById(int id) async {
    // TODO: index all people, parent-subactivities relationships, etc on initialization

    Pessoa? foundPerson;

    for (var page in _activitiesPages) {
      for (var activityJson in page['data']) {
        final activity = Activity.fromJson(activityJson);

        for (var person in activity.people) {
          if (person.id == id) {
            foundPerson ??= person;

            foundPerson.activities.add(activity);
          }
        }
      }
    }

    return foundPerson;
  }
}
