import '/src/feature/articles/model/article.dart';

import 'article_data_provider.dart';

/// Repository for employee data.
abstract interface class ArticleRepository {
  /// Get employee by id.
  Future<List<ArticleModel>> getAllArticles();
}

/// Implementation of the employee repository.
final class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(this._dataProvider);

  /// Employee data provider.
  final ArticleDataProvider _dataProvider;

  @override
  Future<List<ArticleModel>> getAllArticles() => _dataProvider.fetchArticles();
}
