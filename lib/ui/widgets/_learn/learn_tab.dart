class LearnTab {
  final String title;

  LearnTab({
    this.title,
  });

  static List<LearnTab> get items => [
        LearnTab(
          title: 'Overview',
        ),
        LearnTab(
          title: 'Content',
        ),
        LearnTab(
          title: 'Discussion',
        ),
        LearnTab(
          title: 'Learners',
        ),
      ];

  static List<LearnTab> get majorItems => [
        LearnTab(
          title: 'Overview',
        ),
        LearnTab(
          title: 'Content',
        ),
      ];
}
