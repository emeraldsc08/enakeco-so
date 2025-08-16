import 'package:flutter/material.dart';

void toDetail(
  BuildContext context, {
  required Widget page,
  VoidCallback? callback,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page),
  ).then((_) {
    if (callback != null) callback();
  });
}

void toDetailandRemoveUtil(
  BuildContext context, {
  required Widget page,
  VoidCallback? callback,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  ).then((value) {
    {
      if (callback != null) callback();
    }
  });
}

void toDetailandPushReplacement(
  BuildContext context, {
  required Widget page,
  VoidCallback? callback,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  ).then((_) {
    if (callback != null) callback();
  });
}
