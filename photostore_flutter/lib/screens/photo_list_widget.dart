import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/photo_page_bloc.dart';
import 'package:photostore_flutter/components/photo_widget.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';

import '../components/bottom_loader_widget.dart';

class PhotoListTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PhotoPageBloc(RepositoryProvider.of<MediaAPIRepository>(context))
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
        if (state is PhotoPageStateSuccess) {
          if (state.photos.items.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.photos.items.length
                  ? BottomLoaderWidget()
                  : PhotoWidget(photo: state.photos.items[index]);
            },
            itemCount: state.photos.remainingPages > 0
                ? state.photos.items.length
                : state.photos.items.length + 1,
            controller: _scrollController,
          );
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
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _photoPageBloc.add(PhotoPageFetchEvent());
    }
  }
}
