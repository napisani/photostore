import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoGalleryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        height: 200,
        child: Text('photo x'),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: ExactAssetImage('assets/tamas.jpg'),
        //         fit: BoxFit.cover
        //     )
        // ),
      ),
    );
  }

}