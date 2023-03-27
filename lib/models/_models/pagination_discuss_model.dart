import 'package:equatable/equatable.dart';

class PaginationDiscuss extends Equatable {
  final int pageCount;
  final int currentPage;

  const PaginationDiscuss({
    this.pageCount,
    this.currentPage,
  });

  factory PaginationDiscuss.fromJson(Map<String, dynamic> json) {
    return PaginationDiscuss(
      pageCount: json['pageCount'],
      currentPage: json['currentPage'],
    );
  }

  @override
  List<Object> get props => [
        pageCount,
        currentPage,
      ];
}
