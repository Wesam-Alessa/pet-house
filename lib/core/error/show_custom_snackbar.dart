import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MySnackBars {
  /// failure
  static failureSnackBar(String message) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
  }

  /// Waiting
  static waitingSnackBar(String message) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Please Wait...',
        message: message,
        contentType: ContentType.help,
      ),
    );
  }

  /// help
  // static  helpSnackBar( String message) {return  SnackBar(
  //   elevation: 0,
  //   behavior: SnackBarBehavior.floating,
  //   backgroundColor: Colors.transparent,
  //   content: AwesomeSnackbarContent(
  //     title: 'Hi There!',
  //     message:
  //         'You need to use this package in the app to uplift your Snackbar Experinece!',
  //     contentType: ContentType.help,
  //   ),
  // );}

  /// success
  static successSnackBar(String message) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Congratulation!',
        message: message,
        contentType: ContentType.success,
      ),
    );
  }

  /// warning
//   static  warningSnackBar( String message){return SnackBar(
//     elevation: 0,
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: Colors.transparent,
//     content: AwesomeSnackbarContent(
//       title: 'Warning!',
//       message: message,
//       contentType: ContentType.warning,
//     ),
//   );
// }

}
