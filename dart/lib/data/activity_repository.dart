import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../common/assets_manager.dart';
import '../models/activity.dart';

abstract interface class ActivityRepository {
  Future<Iterable<Activity>> fetchActivities([page = 1]);
}

@Singleton(as: ActivityRepository)
class MockedActivityRepository implements ActivityRepository {
  MockedActivityRepository(this.assetsManager);

  final AssetsManager assetsManager;

  late final Iterable<Map<String, dynamic>> _activities;

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

    _activities = jsonFilesStrings.map((e) => json.decode(e));
  }

  @override
  Future<Iterable<Activity>> fetchActivities([page = 1]) async {
    assert(page > 0);

    final data = _activities.elementAtOrNull(page - 1);

    if (data == null) return [];

    final List<dynamic> activitiesJsonList = data["data"];

    final activitiesList = activitiesJsonList.map((e) => Activity.fromJson(e)).toList();

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
}
