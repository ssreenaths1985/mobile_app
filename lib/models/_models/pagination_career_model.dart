import 'package:equatable/equatable.dart';

class PaginationCareer extends Equatable {
  final int pageCount;
  final int currentPage;

  const PaginationCareer({
    this.pageCount,
    this.currentPage,
  });

  factory PaginationCareer.fromJson(Map<String, dynamic> json) {
    return PaginationCareer(
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
