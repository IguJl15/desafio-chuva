import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_exception.dart';
import '../../data/bookmark_repository.dart';
import '../../models/activity.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit(this._bookmarkRepository) : super(BookmarkInitialState());

  final BookmarkRepository _bookmarkRepository;

  Future<void> loadInitialData() async {
    _catching(() async {
      emit(BookmarkLoadingState());

      final list = await _bookmarkRepository.getBookmarkedActivitiesIds();

      emit(BookmarkSuccessState(list));
    });
  }

  void bookmark(Activity activity) async {
    _catching(
      () async {
        emit(BookmarkLoadingState());

        await Future.delayed(const Duration(milliseconds: 400));

        final newList = await _bookmarkRepository.addBookmarkToActivity(activity.id);

        emit(BookmarkSuccessState(newList));
      },
      genericErrorMessage: "Ocorreu um erro desconhecido ao adicionar a atividade à sua agenda.",
    );
  }

  void removeBookmark(Activity activity) async {
    _catching(
      () async {
        emit(BookmarkLoadingState());

        final newList = await _bookmarkRepository.removeBookmarkFromActivity(activity.id);

        emit(BookmarkSuccessState(newList));
      },
      genericErrorMessage: "Ocorreu um erro desconhecido ao remover a atividade da sua agenda.",
    );
  }

  void _catching(void Function() fn, {String genericErrorMessage = "Ocorreu um erro"}) {
    try {
      fn();
    } on AppError catch (e) {
      emit(BookmarkErrorState(e));
    } catch (e) {
      emit(
        BookmarkErrorState(
          AppError(message: "$genericErrorMessage $e"),
        ),
      );
    }
  }
}

sealed class BookmarkState {}

class BookmarkInitialState extends BookmarkState {}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkSuccessState extends BookmarkState {
  final List<int> bookmarkedActivities;

  BookmarkSuccessState(this.bookmarkedActivities);
}

class BookmarkErrorState extends BookmarkState {
  final AppError error;

  BookmarkErrorState(this.error);
}


// Widget que recebe um id e os devidos callbacks para caso esteja carregando, favoritado ou n favoritado