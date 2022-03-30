import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/widget/organization_list_card.dart';
import 'package:flutter/material.dart';

class OrganizationsList extends StatelessWidget {
  final List<OrganizationDetails> organizations;

  const OrganizationsList({Key? key, required this.organizations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        separatorBuilder: (context, pos) => SizedBox(
          width: 16,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, pos) {
          return OrganizationListCard(details: organizations[pos]);
        },
        itemCount: organizations.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}