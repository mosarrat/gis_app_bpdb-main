import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DTMapPopup extends StatelessWidget {
  final String properties;
@override
  void initState() {
    Fluttertoast.showToast(
        msg: properties,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
  const DTMapPopup(this.properties, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Marker Details'),
      content:
          Text(properties), // Display the properties or customize as needed
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
