import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static info(String s) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }

  static error(String s) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }

  static warn(String s) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }
}
