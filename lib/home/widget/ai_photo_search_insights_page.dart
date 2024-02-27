import 'dart:typed_data';

import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/main.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIPhotoSearchInsightsPage extends StatefulWidget {
  final Uint8List imageBytes;

  const AIPhotoSearchInsightsPage({
    Key? key,
    required this.imageBytes,
  }) : super(key: key);

  @override
  State<AIPhotoSearchInsightsPage> createState() => _AIPhotoSearchInsightsPageState();
}

class _AIPhotoSearchInsightsPageState extends State<AIPhotoSearchInsightsPage> {
  var _generatingAIInsights = true;
  var _aiInsights = '';

  @override
  void initState() {
    super.initState();

    final model = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: GEMINI_API_KEY,
    );

    final image = widget.imageBytes;
    final prompt ="""Determine a cosmetics brand from the photo. Check if such cosmetics brand exists. If it doesn't, return "Could not find requested brand". If it exists, provide a detailed cruelty-free status analysis of this brand using the existing criteria: 1) Certifications and blacklist status, 2) Parent company policies, 3) Testing policies of sources and collaborators, 4) Brand's presence in countries with mandatory animal testing laws.""";

    model.generateContent([
      Content.multi([TextPart(prompt), DataPart('image/jpeg', image)]),
    ]).then((value) {
      setState(() {
        _aiInsights = value.text ?? '';
        _generatingAIInsights = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'AI Insights',
        style: AppTypography.header.copyWith(color: AppColors.accentBlack),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            if (_generatingAIInsights)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_aiInsights.isNotEmpty)
              Text(
                _aiInsights,
                style: AppTypography.description.copyWith(
                  color: AppColors.accentBlack,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                  fontSize: 16,
                ),
              ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(LocaleKeys.home_support_dialog_close_button.tr()),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
