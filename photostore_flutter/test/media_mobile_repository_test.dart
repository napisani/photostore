// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:photostore_flutter/services/media_mobile_repository.dart';
//
// void main() {
//   const MethodChannel channel = MethodChannel('photo_gallery');
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   setUp(() {
//     channel.setMockMethodCallHandler(mockMethodCallHandler);
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//
//   test('just test calling the mobile media gallery', () async {
//     final repo = MediaMobileRepository();
//     List<Album> albums = await repo.getPhotoAlbums();
//     print('albums: $albums');
//     expect(albums, isNotNull);
//   });
// }
