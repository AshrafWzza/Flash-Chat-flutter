import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// must return BOOL to use it to check signOut
// Mandatory async await
Future<bool> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) async {
  if (Platform.isAndroid) {
    return await showDialog(
        //barrierDismissible: dismissValue!, // to pass it to  pages
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                if (cancelActionText != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(cancelActionText),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(defaultActionText),
                ),
              ],
            ));
  } else {
    return await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (cancelActionText != null)
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(cancelActionText),
                ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(defaultActionText),
              ),
            ],
          );
        });
  }
}
// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// Future<void>? showAlertDialog(
//     BuildContext context, {
//       required String title,
//       required String content,
//       String? cancelActionText,
//       required String defaultActionText,
//     }) {
//   if (Platform.isAndroid) {
//     showDialog(
//       //barrierDismissible: dismissValue!, // to pass it to  pages
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: [
//             if (cancelActionText != null)
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 },
//                 child: Text(cancelActionText),
//               ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: Text(defaultActionText),
//             ),
//           ],
//         ));
//   } else {
//     showCupertinoDialog(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: Text(title),
//             content: Text(content),
//             actions: [
//               if (cancelActionText != null)
//                 CupertinoDialogAction(
//                   onPressed: () {
//                     Navigator.pop(context, false);
//                   },
//                   child: Text(cancelActionText),
//                 ),
//               CupertinoDialogAction(
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 },
//                 child: Text(defaultActionText),
//               ),
//             ],
//           );
//         });
//   }
// }
