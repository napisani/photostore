// import 'dart:io';
//
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:photostore_flutter/blocs/photo_page_bloc.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_event.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_state.dart';
//
// import '../lib/services/mock_media_repository.dart';
//
// void main() {
//   MockMediaRepository repo;
//
//   setUp(() {
//     repo = MockMediaRepository();
//   });
//
//   group("PhotoPageBloc tests", () {
//     blocTest(
//       "emits a single success when a single Fetch event is added",
//       build: () => AbstractPhotoPageBloc(mediaRepo: repo),
//       act: (bloc) {
//         bloc.add(PhotoPageFetchEvent());
//       },
//       wait: const Duration(milliseconds: 500),
//       expect: [isA<PhotoPageStateSuccess>()],
//     );
//
//     blocTest(
//       "emits a one success when three Fetch events are added",
//       build: () => AbstractPhotoPageBloc(mediaRepo: repo),
//       act: (bloc) {
//         bloc
//           ..add(PhotoPageFetchEvent())
//           ..add(PhotoPageFetchEvent())
//           ..add(PhotoPageFetchEvent());
//         sleep(Duration(seconds: 1));
//       },
//       wait: const Duration(milliseconds: 500),
//       expect: [isA<PhotoPageStateSuccess>()],
//     );
//
//     // group('whenListen', () {
//     //   test("Let's mock the CounterCubit's stream!", () {
//     //     // Create Mock CounterCubit Instance
//     //     final bloc = PhotoPageBloc(repo);
//     //
//     //     expectLater(
//     //         bloc,
//     //         emitsInOrder([
//     //           isA<PhotoPageStateSuccess>(),
//     //           isA<PhotoPageStateSuccess>(),
//     //         ]));
//     //     // Stub the listen with a fake Stream
//     //     bloc.add(PhotoPageFetchEvent());
//     //     bloc.add(PhotoPageFetchEvent());
//     //
//     //
//     //   });
//     // });
//   });
// }
//
// class _isPageNumber extends Matcher {
//   final int page;
//
//   const _isPageNumber(this.page);
//
//   @override
//   bool matches(actual, Map matchState) =>
//       actual is PhotoPageStateSuccess && actual.photos.page == this.page;
//
//   @override
//   Description describe(Description description) =>
//       description.add('page number is $page');
// }
