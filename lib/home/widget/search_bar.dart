import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

typedef OnSearchTermChanged = Function(String searchTerm);

class SearchBar extends StatefulWidget {
  final OnSearchTermChanged onSearchTermChanged;

  const SearchBar({Key? key, required this.onSearchTermChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF2F2F7), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDFE9F5).withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 2),
            )
          ],
        ),
        width: MediaQuery.of(context).size.width - 32,
        // TODO: icon color on focus / not empty controller
        child: TextFormField(
          controller: _searchController,
          cursorColor: AppColors.rose,
          style: AppTypography.regular,
          onChanged: widget.onSearchTermChanged,
          decoration: InputDecoration(
            hintText: LocaleKeys.home_search_hint.tr(),
            hintStyle:
                AppTypography.regular.copyWith(color: AppColors.inactive),
            contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
            focusColor: AppColors.rose,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.inactive,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0.5, color: AppColors.rose),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
