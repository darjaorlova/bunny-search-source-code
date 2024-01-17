import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BunnyAppBarBackButton extends StatelessWidget {
  const BunnyAppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(side: BorderSide()),
            onTap: () {
              Navigator.of(context).pop();
            },
            highlightColor: AppColors.textBlue.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20, right: 4),
              child: SvgPicture.asset(
                ImagesProvider.APP_BAR_BACK,
                color: AppColors.accentBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
