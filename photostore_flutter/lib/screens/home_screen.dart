import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onPush;

  const HomeScreen({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Home');
  }
}
