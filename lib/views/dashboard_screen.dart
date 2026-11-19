import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import '../presenters/dashboard_presenter.dart';
import 'dashboard_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    implements DashboardView {

  late DashboardPresenter presenter;

  bool isLoading = false;

  List<HealthyArticle> articles = [];

  @override
  void initState() {
    super.initState();

    print('DashboardPage initialized');

    presenter = DashboardPresenter(this);

    presenter.loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await presenter.loadArticles();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.article,
                        color: Colors.green,
                      ),

                      title: Text(
                        article.title,
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(article.source),
                          Text(
                            article.category,
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  @override
  void displayArticles(
      List<HealthyArticle> loadedArticles) {
    setState(() {
      articles = loadedArticles;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}