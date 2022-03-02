import 'package:fluttertoast/fluttertoast.dart';
import 'package:mariana_commons/src/ObjectUtil.dart';

class TipUtil {
  static void showToast(String msg, {backgroundColor, textColor}) {
    if (!ObjectUtil.isEmptyString(msg)) {
      Fluttertoast.showToast(msg: "$msg",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: 13.5);
    }
  }
}