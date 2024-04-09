// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/activity_repository.dart' as _i5;
import '../data/bookmark_repository.dart' as _i4;
import 'assets_manager.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AssetsManager>(() => _i3.AssetsManager());
    await gh.singletonAsync<_i4.BookmarkRepository>(
      () {
        final i = _i4.LocalBookmarkRepository();
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    await gh.singletonAsync<_i5.ActivityRepository>(
      () {
        final i = _i5.MockedActivityRepository(gh<_i3.AssetsManager>());
        return i.initialize().then((_) => i);
      },
      preResolve: true,
    );
    return this;
  }
}
