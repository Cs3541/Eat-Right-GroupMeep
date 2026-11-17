import '../models/dashboard_model.dart';

abstract class DashboardView {
  void showLoading();
  void hideLoading();
  void displayArticles(List<HealthyArticle> articles);
  void showError(String message);
}
