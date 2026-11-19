import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dashboard_model.dart';
import '../views/dashboard_view.dart';

class DashboardPresenter {
  final DashboardView view;

  DashboardPresenter(this.view);

  Future<void> loadArticles() async {
  try {
    print('DashboardPresenter.loadArticles called');
    print('Dashboard: Starting Firestore request');

    view.showLoading();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('articles')
        .get()
        .timeout(const Duration(seconds: 15));

    print('Dashboard: Retrieved ${snapshot.docs.length} articles');

    List<HealthyArticle> articles = snapshot.docs
        .map(
          (doc) => HealthyArticle.fromMap(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();

    articles.shuffle();

    view.displayArticles(articles.take(5).toList());
  } catch (e, stackTrace) {
    print('Dashboard error: $e');
    print(stackTrace);

    view.showError('Failed to load articles: $e');
  } finally {
    view.hideLoading();
  }
}
}