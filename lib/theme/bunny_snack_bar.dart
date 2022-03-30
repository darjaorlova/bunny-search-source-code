// The same as in source code
import 'package:bunny_search/theme/app_colors.dart';
import 'package:flutter/material.dart';

const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);

class BunnyDefaultSnackBar extends SnackBar {
  BunnyDefaultSnackBar(
      {Key? key,
      required String text,
      SnackBarBehavior behavior = SnackBarBehavior.floating,
      bool isDismissible = true,
      VoidCallback? onRetry,
      SnackBarAction? action})
      : super(
            key: key,
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(text),
            ),
            backgroundColor: AppColors.textBlue,
            behavior: behavior,
            elevation: 0.0,
            action: onRetry != null
                ? SnackBarAction(label: 'Retry', onPressed: onRetry)
                : action,
            dismissDirection: DismissDirection.endToStart,
            duration: isDismissible && onRetry == null
                ? _snackBarDisplayDuration
                : const Duration(days: 365));
}
