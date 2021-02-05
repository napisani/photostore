import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/blocs/photo_page_bloc.dart';
import 'package:photostore_flutter/components/photo_grid_widget.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';
import 'package:photostore_flutter/services/media_mobile_repositoryV2.dart';

class PhotoListTabWidget extends StatelessWidget {
  final String mediaSource;
  final ValueChanged<int> onPush;

  const PhotoListTabWidget({Key key, this.mediaSource, this.onPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('working on mediaSource: $mediaSource');
    return BlocProvider(
      create: (context) => PhotoPageBloc(
          mediaRepo: (this.mediaSource == 'MOBILE'
              ? RepositoryProvider.of<MediaMobileRepositoryV2>(context)
              : RepositoryProvider.of<MediaAPIRepository>(context)),
          appSettingsBloc: BlocProvider.of<AppSettingsBloc>(context))
        ..add(PhotoPageFetchEvent()),
      child: PhotoListWidget(),
    );
  }
}

class PhotoListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhotoListWidgetState();
}

class _PhotoListWidgetState extends State<PhotoListWidget> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PhotoPageBloc _photoPageBloc;
  double _curOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _photoPageBloc = BlocProvider.of<PhotoPageBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadedEnoughYet());
  }

  void _loadedEnoughYet() {
    if (_photoPageBloc.state is PhotoPageStateSuccess || _photoPageBloc.state is PhotoPageStateInitial) {
      print('after first paint');
      try {
        _scrollController.position;
        print('we are already attached to a scroll view');
        _onScroll();
      } catch (_) {
        _photoPageBloc.add(PhotoPageFetchEvent());
        print('adding fetch!');
      }
    }
  }

  void _adjustScrollOffset(){
    _scrollController.jumpTo(_curOffset);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPageBloc, PhotoPageState>(
      builder: (context, state) {
        print('building state type of: ${state.runtimeType}');
        print('scroll stats: ${_scrollController}');

        if (state is PhotoPageStateInitial) {
          _photoPageBloc.add(PhotoPageFetchEvent());
          return Center(
            child: RaisedButton(child: Text(
              "Load",
            ), onPressed: () {
              _photoPageBloc.add(PhotoPageFetchEvent());
            },),
          );
        } else if (state is PhotoPageStateFailure) {
          return Center(
            child: Text("Error occurred: ${state.errorMessage}"),
          );
        } else if (state is PhotoPageStateSuccess) {
          if (state.photos?.items == null || state.photos.items.isEmpty) {
            return Center(
              child: Text('no photos'),
            );
          }
          // Future.delayed(Duration.zero, () => _adjustScrollOffset());
          return PhotoGridWidget(
              photos: state.photos, scrollController: _scrollController);
        } else {
          throw Exception("invalid PhotoPageState type");
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _photoPageBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print(
        "in _onScroll maxScroll: $maxScroll currentScroll: $currentScroll _scrollThreshold: $_scrollThreshold");
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _curOffset = currentScroll;
      _photoPageBloc.add(PhotoPageFetchEvent());
    }
  }
}
