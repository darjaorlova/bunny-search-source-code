import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShowAllButton extends StatelessWidget {
  final VoidCallback onShowAll;

  const ShowAllButton({Key? key, required this.onShowAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      onPressed: onShowAll,
      child: Text(
        LocaleKeys.home_show_all.tr(),
        style: AppTypography.label,
      ),
    );
  }
}
