import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextSettingInputWidget extends StatelessWidget {

  final String textValue;
  final String prompt;
  final Function savePressed;

  TextSettingInputWidget({
    this.textValue = "",
    this.prompt = "Enter Value",
    this.savePressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController txtController =
    TextEditingController();
    txtController.text = this.textValue;
    return AlertDialog(
      title: Text(prompt),
      content: TextField(controller: txtController),
      actions: [
        ElevatedButton(
            onPressed: () {
              print('cancel pressed');
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              print(
                  'save pressed ${txtController.value.text}');
              Navigator.pop(context);
              if (savePressed != null) {
                savePressed.call(txtController.value.text);
              }
            },
            child: Text("Save"))
      ],
    );
  }
}