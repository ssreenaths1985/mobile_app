class LearnMainTab {
  final String title;

  LearnMainTab({
    this.title,
  });

  static List<LearnMainTab> get items => [
        LearnMainTab(
          title: 'Overview',
        ),
        LearnMainTab(
          title: 'Your learning',
        ),
        LearnMainTab(
          title: 'Explore by',
        ),
        LearnMainTab(
          title: 'Bites',
        ),
      ];
}
