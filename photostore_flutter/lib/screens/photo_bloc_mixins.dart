import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/abstract_photo_page_bloc.dart';
import 'package:photostore_flutter/blocs/mobile_photo_page_bloc.dart';
import 'package:photostore_flutter/blocs/server_photo_page_bloc.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';

abstract class PhotoBlocMixins {
  String getMediaSource();

  getBlockBuilder({BlocWidgetBuilder builder}) => getMediaSource() == 'MOBILE'
      ? BlocBuilder<MobilePhotoPageBloc, PhotoPageState>(builder: builder)
      : BlocBuilder<ServerPhotoPageBloc, PhotoPageState>(builder: builder);

  AbstractPhotoPageBloc getPhotoPageBloc(BuildContext context) =>
      (getMediaSource() == 'MOBILE'
          ? BlocProvider.of<MobilePhotoPageBloc>(context)
          : BlocProvider.of<ServerPhotoPageBloc>(context));
}
