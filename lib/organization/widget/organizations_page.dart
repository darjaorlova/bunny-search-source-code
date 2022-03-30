import 'package:bunny_search/organization/bloc/organizations_bloc.dart';
import 'package:bunny_search/organization/widget/organization_list_card.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/bunny_appbar_back_button.dart';
import 'package:bunny_search/theme/bunny_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrganizationsPageState();

  static Widget withBloc() => BlocProvider(
        create: (context) => OrganizationsBloc(brandsRepository: context.read())
          ..add(LoadEvent()),
        child: OrganizationsPage(),
      );
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  late OrganizationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganizationsBloc, OrganizationsState>(
        listener: (context, state) {
      final isError = state.orgResult.isError == true;
      if (isError) {
        _handleError();
      }
    }, builder: (context, state) {
      final progress = state.orgResult.isInProgress;
      final orgz =
          state.orgResult.isSuccessful ? state.orgResult.value ?? [] : [];
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: BunnyAppBarBackButton(),
          title: Column(
            children: [
              Text(
                LocaleKeys.organizations_title.tr(),
                style: AppTypography.h4,
              ),
            ],
          ),
        ),
        body: progress
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.rose,
                ),
              )
            : SafeArea(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2),
                  itemBuilder: (context, pos) {
                    return OrganizationListCard(details: orgz[pos]);
                  },
                  itemCount: orgz.length,
                ),
              ),
      );
    });
  }

  void _handleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      BunnyDefaultSnackBar(
          text: LocaleKeys.general_error.tr(),
          onRetry: () => _bloc.add(LoadEvent())),
    );
  }
}
