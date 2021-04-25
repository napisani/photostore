import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/viewmodel/server_refinement_model.dart';
import 'package:provider/provider.dart';

class ServerRefinementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ServerRefinementModel(),
        child: _ServerRefinementScreen());
  }
}

class _ServerRefinementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
