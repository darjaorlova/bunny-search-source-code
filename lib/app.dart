import 'package:bunny_search/app_routes.dart';
import 'package:bunny_search/home/widget/home_page.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/utils/widget/focus_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final easyLocalization = EasyLocalization.of(context)!;
    return GestureDetector(
      onTap: () => FocusUtils.unfocus(context),
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => tr(LocaleKeys.app_title),
        localizationsDelegates: easyLocalization.delegates,
        supportedLocales: easyLocalization.supportedLocales,
        locale: easyLocalization.locale,
        home: HomePage.withBloc(),
        theme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData().copyWith(
              primaryColor: AppColors.rose,
              textTheme: CupertinoTextThemeData()
                  .copyWith(primaryColor: AppColors.rose)),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.rose,
              selectionColor: AppColors.rose.withOpacity(0.5),
              selectionHandleColor: AppColors.rose.withOpacity(0.5)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.rose,
            secondary: AppColors.inactive,
          ),
        ),
        initialRoute: AppRoutes.root,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.root:
              return MaterialPageRoute(
                  settings: const RouteSettings(name: AppRoutes.root),
                  builder: (settings) => _PlaceholderContainer());
            default:
              return MaterialPageRoute(
                  settings: const RouteSettings(name: AppRoutes.root),
                  builder: (settings) => _PlaceholderContainer());
          }
        },
      ),
    );
  }
}

class _PlaceholderContainer extends StatelessWidget {
  const _PlaceholderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD8CCFF), Color(0xFFA3E3FF)],
          tileMode: TileMode.clamp,
        )));
  }
}
