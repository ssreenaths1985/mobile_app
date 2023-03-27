import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MultiSelectItem extends Equatable {
  final String itemName;
  bool isSelected;

  MultiSelectItem({
    this.itemName,
    this.isSelected,
  });

  @override
  List<Object> get props => [itemName, isSelected];
}
