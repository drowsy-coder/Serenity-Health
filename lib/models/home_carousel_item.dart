class CarouselItem {
  final String title;
  final String description;
  final String imageAssetPath;
  final String redirectLink;

  CarouselItem({
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.redirectLink,
  });
}

List<CarouselItem> carouselItems = [
  CarouselItem(
    title: "How to Prevent Heart Attacks",
    description: "Learn about the best practices to prevent heart attacks.",
    imageAssetPath: "assets/images/attack.jpg",
    redirectLink:
        "https://www.moneycontrol.com/news/health-and-fitness/how-to-prevent-heart-attacks-dont-skip-your-leg-exercises-in-the-gym-10718931.html",
  ),
  CarouselItem(
    title: "Benefits of Exercise",
    description: "Discover the numerous benefits of regular exercise.",
    imageAssetPath: "assets/images/exerc.png",
    redirectLink:
        "https://zeenews.india.com/health/benefits-of-exercise-daily-movement-can-help-reduce-the-risk-of-type-2-diabetes-2618522",
  ),
  CarouselItem(
    title: "Tips for a Healthy Diet",
    description: "Get valuable tips for maintaining a healthy diet.",
    imageAssetPath: "assets/images/diet.jpg",
    redirectLink:
        "https://www.india.com/lifestyle/healthy-diet-101-7-diet-tips-to-lose-weight-and-improve-overall-health-6082632/",
  ),
];
