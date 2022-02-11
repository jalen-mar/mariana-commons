import 'package:mariana_commons/src/RegexUtil.dart';
import 'package:mariana_commons/src/TipUtil.dart';

class ObjectUtil {
  static bool isEmptyString(String? str) {
    return str == null || str.isEmpty;
  }

  static bool isEmptyList(Iterable? list) {
    return list == null || list.isEmpty;
  }

  static bool isEmptyMap(Map? map) {
    return map == null || map.isEmpty;
  }

  static bool isEmpty(Object? object) {
    if (object is String) {
      return isEmptyString(object);
    } else if (object is Iterable) {
      return isEmptyList(object);
    } else if (object is Map) {
      return isEmptyMap(object);
    }
    return true;
  }

  static bool mobile(String? mobile) {
    bool result = false;
    if (between(mobile, 11, 11)) {
      result = RegexUtil.regexMobile.contains(mobile!.substring(0, 2));
    }
    return result;
  }

  static bool between(String? value, int min, int max) {
    bool result = false;
    if (!isEmpty(value)) {
      int length = value!.trim().length;
      result = length >= min && length <= max;
    }
    return result;
  }

  static bool equals(String? v1, String? v2) {
    bool result = false;
    if (!isEmpty(v1) && v1 == v2) {
      result = true;
    }
    return result;
  }

  ObjectUtil? isNotEmpty(Object? value, String msg) {
    return _check(!isEmpty(value), msg);
  }

  ObjectUtil? isMobile(String? value, String msg) {
    return _check(mobile(value), msg);
  }

  ObjectUtil? isBetween(String? value, int min, int max, String msg) {
    return _check(between(value, min, max), msg);
  }

  ObjectUtil? isEquals(String? v1, String? v2, String msg) {
    return _check(equals(v1, v2), msg);
  }

  ObjectUtil? isNotEquals(String? v1, String? v2, String msg) {
    return _check(!equals(v1, v2), msg);
  }

  ObjectUtil? isCheck(bool value, String msg) {
    return _check(value, msg);
  }

  static ObjectUtil getInstance() {
    return ObjectUtil._();
  }

  ObjectUtil._();

  ObjectUtil? _check(bool val, String msg) {
    ObjectUtil? result;
    if (val) {
      result = this;
    } else {
      TipUtil.showToast(msg);
    }
    return result;
  }

  void run(Function task) {
    task.call();
  }
}