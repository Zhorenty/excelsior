import 'package:flutter/material.dart';

import '/src/feature/articles/model/article.dart';

/// {@template article_detail_page}
/// ArticleDetailScreen widget
/// {@endtemplate}
class ArticleDetailScreen extends StatelessWidget {
  /// {@macro article_detail_page}
  const ArticleDetailScreen({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Article detail')),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox.square(dimension: 16),
                Text(
                  article.body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
