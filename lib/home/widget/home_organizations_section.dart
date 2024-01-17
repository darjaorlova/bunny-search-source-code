import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/home/widget/organizations_list.dart';
import 'package:bunny_search/home/widget/show_all_button.dart';
import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/widget/organizations_page.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeOrganizationsSection extends StatelessWidget {
  final List<OrganizationDetails> organizations;

  const HomeOrganizationsSection({Key? key, required this.organizations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.home_organizations.tr(),
                style: AppTypography.headerMedium,
              ),
              ShowAllButton(
                onShowAll: () => _showAllOrganizations(context),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        OrganizationsList(
          organizations: organizations,
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  void _showAllOrganizations(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrganizationsPage.withBloc()),
    );
  }
}
