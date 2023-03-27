class AssistantTab {
  final String title;
  final int tabNumber;

  AssistantTab({this.title, this.tabNumber});

  static List<AssistantTab> get items => [
        AssistantTab(title: 'All', tabNumber: 1),
        AssistantTab(title: 'Network', tabNumber: 2),
        AssistantTab(title: 'Discuss', tabNumber: 3),
        AssistantTab(title: 'Learn', tabNumber: 4),
        AssistantTab(title: 'Careers', tabNumber: 5),
      ];
}
