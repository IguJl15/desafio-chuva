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

    final activitiesList = activitiesJsonList.map((e) => Activity.fromJson(e));

    return activitiesList;
  }
}
