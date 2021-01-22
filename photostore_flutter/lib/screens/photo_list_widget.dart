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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _photoPageBloc = BlocProvider.of<PhotoPageBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadedEnoughYet());
  }

  void _loadedEnoughYet() {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPageBloc, PhotoPageState>(
      builder: (context, state) {
        if (state is PhotoPageStateInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PhotoPageStateFailure) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is PhotoPageStateSuccess || state is PhotoPageStateLoading) {
          if (state.photos?.items == null || state.photos.items.isEmpty) {
            return Center(
              child: Text('no photos'),
            );
          }
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
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print(
        "in _onScroll maxScroll: $maxScroll currentScroll: $currentScroll _scrollThreshold: $_scrollThreshold");
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _photoPageBloc.add(PhotoPageFetchEvent());
    }
  }
}
