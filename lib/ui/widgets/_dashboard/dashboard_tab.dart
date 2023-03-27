class DashboardTab {
  final String title;

  DashboardTab({
    this.title,
  });

  static List<DashboardTab> get items => [
        DashboardTab(
          title: 'Overview',
        ),
        DashboardTab(
          title: 'Leaderboard',
        ),
        DashboardTab(
          title: 'Dashboard 2',
        ),
        DashboardTab(
          title: 'Dashboard 3',
        ),
      ];
}
