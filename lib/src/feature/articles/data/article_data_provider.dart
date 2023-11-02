import 'package:dio/dio.dart';

import '../model/article.dart';

/// Datasource for profile data.
abstract interface class ArticleDataProvider {
  Future<List<ArticleModel>> fetchArticles();
}

/// Implementation of employee datasource.
class ArticleDataProviderImpl implements ArticleDataProvider {
  ArticleDataProviderImpl({required this.restClient});

  /// REST client to call API.
  final Dio restClient;

  @override
  Future<List<ArticleModel>> fetchArticles() async {
    final response = await restClient.get('/posts');

    final articles = List.from((response.data as List))
        .map((e) => ArticleModel.fromJson(e))
        .toList();

    return articles;
  }
}
