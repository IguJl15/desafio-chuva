import 'dart:io';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chuva_dart/data/activity_repository.dart';
import 'package:chuva_dart/common/assets_manager.dart';

class MockAssetsManager extends Mock implements AssetsManager {}

void main() async {
  final assetsManager = MockAssetsManager();
  final fooContent = await File("test/fixtures/foo.json").readAsString();
  final barContent = await File("test/fixtures/bar.json").readAsString();

  group('activity mocked (fixture) repository', () {
    setUp(() {
      when(() => assetsManager.loadString("foo.json")).thenAnswer((_) async {
        return fooContent;
      });
      when(() => assetsManager.loadString("bar.json")).thenAnswer((_) async {
        return barContent;
      });
    });

    test('should load first fifty elements from first fixture json', () async {
      //Arrange
      final repository = MockedActivityRepository(assetsManager);
      await repository.initialize(resources: ["foo.json"]);

      //Act
      final activities = await repository.fetchActivities();
      //Assert

      expect(activities.length, 50);
      expect(activities.first.id, 8921);
      expect(activities.first.title.value, "A F\u{00ed}sica dos Buracos Negros Supermassivos");
      expect(activities.first.category.id, 11372);
      expect(activities.first.category.color, "#C24FFE");
      expect(activities.first.event, "teste-exercicio");
    });

    test('should load second page from second json', () async {
      //Arrange
      final repository = MockedActivityRepository(assetsManager);
      await repository.initialize(resources: ["foo.json", "bar.json"]);

      //Act
      final activities = await repository.fetchActivities(2);
      //Assert

      expect(activities.length, 21);
      expect(activities.first.id, 8969);
      expect(activities.first.title.value,
          "Cosmologia em Evolução: Compreendendo o Futuro do Universo");
      expect(activities.first.category.id, 11373);
      expect(activities.first.category.color, "#29CFC9");
      expect(activities.first.event, "teste-exercicio");
    });

    test('should return empty list when method is requested with invalid page number', () async {
      //Arrange
      final repository = MockedActivityRepository(assetsManager);
      await repository.initialize(resources: ["foo.json"]);

      //Act
      final activities = await repository.fetchActivities(3);
      //Assert

      expect(activities.length, 0);
    });
  });
}
