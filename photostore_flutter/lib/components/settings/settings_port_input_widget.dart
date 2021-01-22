import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SettingsPortInputWidget extends StatelessWidget {
  final int port;
  final Function savePressed;

  SettingsPortInputWidget({ this.port = 5000, this.savePressed}) {}

  @override
  Widget build(BuildContext context) {
    final TextEditingController txtController =
    TextEditingController();

    txtController.text = "${this.port}";
    return AlertDialog(
      title: Text("Enter Port Number"),
      content: TextField(controller: txtController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
      ),
      actions: [
        FlatButton(
            onPressed: () {
              print('cancel pressed');
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        FlatButton(
            onPressed: () {
              print(
                  'save pressed ${txtController.value.text}');
              Navigator.pop(context);
              if (savePressed != null) {
                savePressed.call(int.parse(txtController.value.text));
              }
            },
            child: Text("Save"))
      ],
    );
  }

}
