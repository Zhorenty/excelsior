import 'package:excelsior/src/feature/articles/model/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../data/article_repository.dart';
import '/src/core/utils/logger.dart';
import '/src/core/utils/pattern_match.dart';

/// {@template Article_event}
/// Article event
/// {@endtemplate}
@immutable
sealed class ArticleEvent with _ArticleEvent {
  /// {@macro Article_event}
  const ArticleEvent();

  /// FetchAll the Article
  const factory ArticleEvent.fetchAll() = _ArticleEventFetchAll;
}

final class _ArticleEventFetchAll extends ArticleEvent {
  const _ArticleEventFetchAll();
}

abstract base mixin class _ArticleEvent {
  const _ArticleEvent();

  T map<T>({
    required PatternMatch<T, _ArticleEventFetchAll> fetchAll,
  }) =>
      switch (this) {
        final _ArticleEventFetchAll event => fetchAll(event),
        _ => throw AssertionError('Unknown event: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _ArticleEventFetchAll>? fetchAll,
    required T orElse,
  }) =>
      map(
        fetchAll: fetchAll ?? (_) => orElse,
      );
}

/// {@template Article_state}
/// Article state
/// {@endtemplate}
@immutable
sealed class ArticleState with _ArticleState {
  /// {@macro Article_state}
  const ArticleState();

  /// Idle state
  const factory ArticleState.idle(List<ArticleModel> articles) =
      _ArticleStateIdle;

  /// In Progress state
  const factory ArticleState.inProgress(List<ArticleModel> articles) =
      _ArticleStateInProgress;
}

final class _ArticleStateIdle extends ArticleState {
  @override
  final List<ArticleModel> articles;

  const _ArticleStateIdle(this.articles);

  @override
  String toString() => 'ArticleState.idle(Article: $articles)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ArticleStateIdle &&
          runtimeType == other.runtimeType &&
          articles == other.articles);

  @override
  int get hashCode => articles.hashCode;
}

final class _ArticleStateInProgress extends ArticleState {
  @override
  final List<ArticleModel> articles;

  const _ArticleStateInProgress(this.articles);

  @override
  String toString() => 'ArticleState.inProgress(Article: $articles)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ArticleStateInProgress &&
          runtimeType == other.runtimeType &&
          articles == other.articles);

  @override
  int get hashCode => articles.hashCode;
}

abstract base mixin class _ArticleState {
  const _ArticleState();

  /// Current Article
  List<ArticleModel> get articles;

  /// Indicator whether state is processing now.
  bool get inProgress => maybeMap(
        inProgress: (_) => true,
        idle: (_) => false,
        orElse: false,
      );

  T map<T>({
    required PatternMatch<T, _ArticleStateIdle> idle,
    required PatternMatch<T, _ArticleStateInProgress> inProgress,
  }) =>
      switch (this) {
        final _ArticleStateIdle state => idle(state),
        final _ArticleStateInProgress state => inProgress(state),
        _ => throw AssertionError('Unknown state: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _ArticleStateIdle>? idle,
    required PatternMatch<T, _ArticleStateInProgress>? inProgress,
    required T orElse,
  }) =>
      map(
        idle: idle ?? (_) => orElse,
        inProgress: inProgress ?? (_) => orElse,
      );
}

/// {@template Article_bloc}
/// Business logic components that can switch Articles.
///
/// It communicates with provided repository to persist the Article.
///
/// Should not be used directly, instead use [ArticleScope].
/// It operates ArticleBloc under the hood.
/// {@endtemplate}
final class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository _articleRepository;

  /// {@macro Article_bloc}
  ArticleBloc(this._articleRepository) : super(const ArticleState.idle([])) {
    on<ArticleEvent>(
      (event, emit) => event.map(
        fetchAll: (e) => _getAll(e, emit),
      ),
    );
  }

  Future<void> _getAll(
    _ArticleEventFetchAll event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      emit(ArticleState.inProgress(state.articles));
      final articles = await _articleRepository.getAllArticles();
      emit(ArticleState.idle(articles));
    } catch (e) {
      logger.warning(
        'Failed to FetchAll Article to $event, reverting to ${state.articles}',
      );
      emit(ArticleState.idle(state.articles));
      rethrow;
    }
  }
}
