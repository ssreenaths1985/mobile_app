class NetworkProfileTab {
  final String title;

  NetworkProfileTab({
    this.title,
  });

  static List<NetworkProfileTab> get items => [
        NetworkProfileTab(
          title: 'Profile',
        ),
        NetworkProfileTab(
          title: 'Discussions',
        ),
        NetworkProfileTab(
          title: 'Upvotes',
        ),
      ];
}
