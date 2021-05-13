class PhotoDateRanges {
  final DateTime creationDateStart;
  final DateTime creationDateEnd;
  final DateTime modifiedDateStart;
  final DateTime modifiedDateEnd;

  PhotoDateRanges(
      {this.creationDateStart,
      this.creationDateEnd,
      this.modifiedDateStart,
      this.modifiedDateEnd});

  factory PhotoDateRanges.fromJson(Map<String, dynamic> data) {
    return PhotoDateRanges(
      creationDateStart: DateTime.tryParse(data['creation_date_start'] ?? ''),
      modifiedDateStart: DateTime.tryParse(data['modified_date_start'] ?? ''),
      creationDateEnd: DateTime.tryParse(data['creation_date_end'] ?? ''),
      modifiedDateEnd: DateTime.tryParse(data['modified_date_end'] ?? ''),
    );
  }
}
