import 'dart:convert';

import 'package:chuva_dart/main.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart';

abstract interface class ActivityRepository {
  List<Activity> fetchActivities([page = 1]);
}

class MockedActivityRepository implements ActivityRepository {
  static MockedActivityRepository? _instance;
  // Avoid self instance
  MockedActivityRepository._();
  static MockedActivityRepository get instance => _instance ??= MockedActivityRepository._()..init();

  void init() {
    final resources = ["assets/activities.json", "assets/activities1.json"];

    activities = [
      json.decode(resources[0]),
      json.decode(resources[1]),
    ];
  }

  late final List<Map<String, dynamic>> activities;

  List<Activity> fetchActivities([page = 1]) {
    final data = activities[page - 1];

    final activitiesList = 
    return [];
  }
}
