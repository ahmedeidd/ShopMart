import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matjar_app/layout/shop_layout_screen.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/modules/login_screen/login_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/app_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';
import 'package:matjar_app/shard/remote/dio_helper.dart';
import 'package:matjar_app/shard/themes/themes.dart';
import 'package:sizer/sizer.dart';
import 'localization/demo_localization.dart';
import 'modules/on_bording_screen/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.dioInit();
  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? showOnBoard = CacheHelper.getData(key: 'ShowOnBoard');
  token = CacheHelper.getData(key: 'token');

  if (showOnBoard == false) {
    if (token != null)
      widget = ShopLayoutScreen();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(
    MyApp(
      isDark: isDark,
      startWidget: widget,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool? isDark;
  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoryData()
            ..getFavoriteData()
            ..getProfileData()
            ..getCartData()
            ..getAddresses(),
        ),
      ],
      child: BlocConsumer<AppCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: _locale,
                supportedLocales: [
                  Locale("en", "US"),
                  Locale("ar", "SA"),
                ],
                localizationsDelegates: [
                  DemoLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                home: widget.startWidget,
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: cubit.appMode,
              );
            },
          );
        },
      ),
    );
  }
}
