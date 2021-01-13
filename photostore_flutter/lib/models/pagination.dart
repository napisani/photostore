import 'package:equatable/equatable.dart';

/*
  items: Array<T>;
  itemSlices: Array<Array<T>>;
  perPage: number;
  total: number;
  page: number;
  remainingPages: number;
 */
class Pagination<T> extends Equatable {
  final List<T> items;
  final int perPage;
  final int total;
  final int page;
  final int remainingPages;

  const Pagination(
      {this.items, this.perPage, this.total, this.page, this.remainingPages});

  @override
  List<Object> get props => [items, perPage, total, page, remainingPages];
}
