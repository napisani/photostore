class PhotoDiffResult {
  final String photoId;
  final String nativeId;
  final String deviceId;
  final bool exists;
  final bool sameDate;
  final bool sameChecksum;

  PhotoDiffResult(
      {this.photoId,
      this.nativeId,
      this.deviceId,
      this.exists,
      this.sameDate,
      this.sameChecksum});

  factory PhotoDiffResult.fromJson(Map<String, dynamic> json) {
    return PhotoDiffResult(
        photoId: json['photo_id'].toString(),
        nativeId: json['native_id'],
        deviceId: json['device_id'],
        exists: json['exists'],
        sameDate: json['same_date'],
        sameChecksum: json['same_checksum']);
  }
}
