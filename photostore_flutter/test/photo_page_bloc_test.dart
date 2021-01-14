import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photostore_flutter/blocs/photo_page_bloc.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';

import 'utils/mock_media_repository.dart';

void main() {
  MockMediaRepository repo;

  setUp(() {
    repo = MockMediaRepository();
  });

  group("PhotoPageBloc tests", () {
    blocTest(
      "emits a single success when a single Fetch event is added",
      build: () => PhotoPageBloc(repo),
      act: (bloc) => bloc.add(PhotoPageFetchEvent()),
      expect: [isA<PhotoPageStateSuccess>()],
    );

    blocTest(
      "emits a multiple success when two Fetch event are added",
      build: () => PhotoPageBloc(repo),
      act: (bloc) async => bloc
        ..add(PhotoPageFetchEvent())
        ..add(PhotoPageFetchEvent())
        ..add(PhotoPageFetchEvent()),
      expect: [
        isA<PhotoPageStateSuccess>(),
        isA<PhotoPageStateSuccess>(),
        isA<PhotoPageStateSuccess>()
      ],
    );

    // group('whenListen', () {
    //   test("Let's mock the CounterCubit's stream!", () {
    //     // Create Mock CounterCubit Instance
    //     final bloc = PhotoPageBloc(repo);
    //
    //     expectLater(
    //         bloc,
    //         emitsInOrder([
    //           isA<PhotoPageStateSuccess>(),
    //           isA<PhotoPageStateSuccess>(),
    //         ]));
    //     // Stub the listen with a fake Stream
    //     bloc.add(PhotoPageFetchEvent());
    //     bloc.add(PhotoPageFetchEvent());
    //
    //
    //   });
    // });
  });
}

class _isPageNumber extends Matcher {
  final int page;

  const _isPageNumber(this.page);

  @override
  bool matches(actual, Map matchState) =>
      actual is PhotoPageStateSuccess && actual.photos.page == this.page;

  @override
  Description describe(Description description) =>
      description.add('page number is $page');
}
