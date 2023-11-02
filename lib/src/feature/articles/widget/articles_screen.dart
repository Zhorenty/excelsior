import 'package:excelsior/src/feature/articles/bloc/articles_bloc.dart';
import 'package:excelsior/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/core/localization/localization.dart';
import 'article_detail_screen.dart';

/// {@template article_page}
/// ArticleScreen widget
/// {@endtemplate}
class ArticleScreen extends StatefulWidget {
  /// {@macro article_page}
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final ArticleBloc articleBloc;

  @override
  void initState() {
    super.initState();
    articleBloc = ArticleBloc(DependenciesScope.of(context).articleRepository)
      ..add(const ArticleEvent.fetchAll());
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: articleBloc,
        child: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text(Localization.of(context).appTitle),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            article: state.articles[index],
                          ),
                        ),
                      ),
                      child: _ArticleContainer(
                        title: state.articles[index].title,
                        subtitle: state.articles[index].body,
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox.square(dimension: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// {@template article_container}
/// Article container widget
/// {@endtemplate}
class _ArticleContainer extends StatelessWidget {
  /// {@macro article_container}
  const _ArticleContainer({required this.title, required this.subtitle});

  final String title;

  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$title\n',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(
                text: subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
