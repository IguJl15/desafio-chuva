import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_exception.dart';

abstract interface class BookmarkRepository {
  Future<List<int>> getBookmarkedActivitiesIds();

  /// Returns the updated bookmarked activities list
  Future<List<int>> addBookmarkToActivity(int id);
  Future<List<int>> removeBookmarkFromActivity(int id);
}

@Singleton(as: BookmarkRepository)
class LocalBookmarkRepository implements BookmarkRepository {
  static const String key = "local_bookmark_activities_ids";

  late final SharedPreferences _localStorage;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  @override
  Future<List<int>> getBookmarkedActivitiesIds() async {
    return _getIds();
  }

  @override
  Future<List<int>> addBookmarkToActivity(int id) async {
    final list = await getBookmarkedActivitiesIds();

    list.add(id);

    final succeed = await _setIds(list);

    if (succeed) {
      return list;
    } else {
      throw AppError(message: "Ocorreu um erro desconhecido ao adicionar a atividade à sua agenda");
    }
  }

  @override
  Future<List<int>> removeBookmarkFromActivity(int id) async {
    final list = await getBookmarkedActivitiesIds();

    list.remove(id);

    final succeed = await _setIds(list);

    if (succeed) {
      return list;
    } else {
      throw AppError(message: "Ocorreu um erro desconhecido ao remover a atividade da sua agenda");
    }
  }

  Future<bool> _setIds(List<int> list) async =>
      await _localStorage.setStringList(key, list.map((e) => "$e").toList());

  List<int> _getIds() {
    return _localStorage //
            .getStringList(key)
            ?.map((e) => int.tryParse(e) ?? 0)
            .toList() ??
        [];
  }
}
