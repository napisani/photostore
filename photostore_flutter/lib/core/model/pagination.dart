import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  final List<T> items;
  final int perPage;
  final int total;
  final int page;

  bool isEmpty()=> items == null || items.length  == 0;

  int get remainingPages => ((total - (page * perPage)) / perPage).ceil();

  bool get hasMorePages => this.page == 0 || remainingPages > 0;

  const Pagination(
      {this.items = const [], this.perPage = 0, this.total = 0, this.page = 0});

  factory Pagination.combineWith(Pagination<T> p, Pagination<T> p2) {
    if (p == null || p.items == null || p.items.isEmpty) {
      return p2;
    }
    final List<T> newItems = [...p?.items, ...p2?.items];
    return new Pagination(
        items: newItems,
        perPage: p2.perPage,
        page: p2.page,
        total: p2.total);
  }

  @override
  List<Object> get props => [items, perPage, total, page];
}
