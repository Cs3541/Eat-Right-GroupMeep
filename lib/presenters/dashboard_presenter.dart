import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dashboard_model.dart';
import '../views/dashboard_view.dart';

class DashboardPresenter {
  final DashboardView view;

  DashboardPresenter(this.view);

  Future<void> loadArticles() async {
    try {
      view.showLoading();

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('articles')
              .get();

      List<HealthyArticle> articles = snapshot.docs
          .map(
            (doc) => HealthyArticle.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      articles.shuffle();

      view.displayArticles(
        articles.take(5).toList(),
      );

      view.hideLoading();
    } catch (e) {
      view.hideLoading();
      view.showError(
        'Failed to load articles: $e',
      );
    }
  }
}