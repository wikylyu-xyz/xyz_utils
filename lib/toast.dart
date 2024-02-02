import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  ToastService._internal();
  static final ToastService instance = ToastService._internal();

  info(String s, {Toast? toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }

  error(String s, {Toast? toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }

  warn(String s, {Toast? toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: s,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }
}
