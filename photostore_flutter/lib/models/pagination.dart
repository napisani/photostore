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

  int get remainingPages => ((total - (page * perPage)) / perPage).ceil();

  const Pagination({this.items, this.perPage, this.total, this.page});

  Pagination<T> combineWith(Pagination<T> p2) {
    return new Pagination(
        items: this.items..addAll(p2.items),
        perPage: p2.perPage,
        page: p2.page);
  }

  @override
  List<Object> get props => [items, perPage, total, page];
}
