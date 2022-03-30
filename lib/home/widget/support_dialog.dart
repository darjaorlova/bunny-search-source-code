import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SupportDialog extends StatelessWidget {
  const SupportDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocaleKeys.home_support_dialog_title.tr(),
        style: AppTypography.header.copyWith(color: AppColors.accentBlack),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              LocaleKeys.home_support_dialog_content.tr(),
              style: AppTypography.description.copyWith(
                  color: AppColors.accentBlack,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              LocaleKeys.home_support_dialog_team.tr(),
              style: AppTypography.description.copyWith(
                  color: AppColors.accentBlack,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  fontSize: 16),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(LocaleKeys.home_support_dialog_close_button.tr()),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
