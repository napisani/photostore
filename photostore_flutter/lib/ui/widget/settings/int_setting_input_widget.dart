import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class IntegerSettingInputWidget extends StatelessWidget {
  final int intValue;
  final Function savePressed;
  final String prompt;

  IntegerSettingInputWidget(
      {this.intValue, this.savePressed, this.prompt = 'Enter Value'});

  @override
  Widget build(BuildContext context) {
    final TextEditingController txtController = TextEditingController();

    txtController.text = "${this.intValue}";
    return AlertDialog(
      title: Text(prompt),
      content: TextField(
        controller: txtController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
      ),
      actions: [
        TextButton(
            onPressed: () {
              print('cancel pressed');
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              print('save pressed ${txtController.value.text}');
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
