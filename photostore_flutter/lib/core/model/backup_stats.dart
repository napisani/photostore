class BackupStats {
  final int backedUpPhotoCount;
  final int mobilePhotoCount;
  final String lastBackedUpPhotoId;
  final DateTime lastBackedUpPhotoModifyDate;

  const BackupStats({this.backedUpPhotoCount,this.mobilePhotoCount,  this.lastBackedUpPhotoId,
      this.lastBackedUpPhotoModifyDate});
}
