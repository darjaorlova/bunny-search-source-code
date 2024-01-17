import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/home/bloc/home_bloc.dart';
import 'package:bunny_search/home/widget/home_content_screen.dart';
import 'package:bunny_search/home/widget/home_splash_screen.dart';
import 'package:bunny_search/home/widget/support_dialog.dart';
import 'package:bunny_search/theme/bunny_snack_bar.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();

  static Widget withBloc() => BlocProvider(
        create: (context) => HomeBloc(
          brandsRepository: context.read(),
          keyValueStorage: context.read(),
        )..add(LoadEvent()),
        child: const HomePage(),
      );
}

class _HomePageState extends State<HomePage> {
  String searchTerm = '';
  late HomeBloc _bloc;
  late Widget _widget;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeBlocState>(
      listener: (context, state) {
        final isError = state.organizationsResult.isError == true ||
            state.searchResult.orNull?.isError == true;
        if (isError) {
          _handleError();
        } else if (state.showSupportDialog) {
          _showSupportDialog();
          _bloc.add(SetSupportDialogShownEvent());
        }
      },
      builder: (context, state) {
        final isLoadingData = state.organizationsResult.isInProgress == true ||
            state.organizationsResult.isError == true;
        final showSearchResults =
            state.searchResult.orNull?.isSuccessful == true;
        final showProgress = state.searchResult.orNull?.isInProgress == true;
        final showPopularBrands = !showSearchResults && !showProgress;
        final showOrganizations =
            state.organizationsResult.isSuccessful == true &&
                !showSearchResults &&
                !showProgress;
        final brands = state.searchResult.orNull?.result?.value ?? <Brand>[];
        final organizations = state.organizationsResult.value ?? [];
        if (isLoadingData) {
          _widget = const HomeSplashScreen();
        } else {
          _widget = HomeContentScreen(
            showProgress: showProgress,
            showOrganizations: showOrganizations,
            showPopularBrands: showPopularBrands,
            showSearchResults: showSearchResults,
            searchBrands: brands,
            popularBrands: state.popularBrands,
            organizations: organizations,
            onSearchTermChanged: (searchTerm) =>
                _bloc.add(SearchEvent(searchTerm: searchTerm)),
          );
        }
        return AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration: const Duration(milliseconds: 750),
          child: _widget,
        );
      },
    );
  }

  void _handleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      BunnyDefaultSnackBar(
        text: LocaleKeys.general_error.tr(),
        onRetry: () => _bloc.add(LoadEvent()),
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(context: context, builder: (context) => const SupportDialog());
  }
}
