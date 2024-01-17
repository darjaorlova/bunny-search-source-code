import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BunnyBackButton extends StatelessWidget {
  const BunnyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white),
            ),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(side: BorderSide()),
                onTap: () {
                  Navigator.of(context).pop();
                },
                highlightColor: AppColors.textBlue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    ImagesProvider.BACK,
                    color: AppColors.textBlue,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
