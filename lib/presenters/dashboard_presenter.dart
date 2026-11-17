import '../models/dashboard_model.dart';
import '../views/dashboard_view.dart';

class DashboardPresenter {
  final DashboardView view;

  DashboardPresenter(this.view);

  Future<void> loadArticles() async {
    view.showLoading();

    try {
      await Future.delayed(const Duration(seconds: 1));

      List<HealthyArticle> articles = [
        HealthyArticle(
          title: "Healthy Eating Plate Guide",
          source: "Harvard Nutrition Source",
          imageUrl:
              "https://images.unsplash.com/photo-1490645935967-10de6ba17061",
          summary:
              "Build healthy meals using vegetables, fruits, whole grains, and healthy proteins.",
          articleUrl:
              "https://nutritionsource.hsph.harvard.edu/healthy-eating-plate/",
        ),
        HealthyArticle(
          title: "Nutrition Basics",
          source: "USDA MyPlate",
          imageUrl:
              "https://images.unsplash.com/photo-1547592180-85f173990554",
          summary:
              "Learn how much of each food group belongs on your plate.",
          articleUrl: "https://www.myplate.gov",
        ),
        HealthyArticle(
          title: "Healthy Diet Tips",
          source: "Mayo Clinic",
          imageUrl:
              "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
          summary:
              "Simple nutrition habits that improve long-term health.",
          articleUrl:
              "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating",
        ),
      ];

      view.displayArticles(articles);
    } catch (e) {
      view.showError("Failed to load articles.");
    }

    view.hideLoading();
  }
}