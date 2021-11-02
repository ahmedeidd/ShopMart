import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/main.dart';
import 'package:matjar_app/models/language.dart';
import 'package:matjar_app/modules/FAQs_screen/help_screen.dart';
import 'package:matjar_app/modules/addresses_screen/addresses_screen.dart';
import 'package:matjar_app/modules/profile_screen/profile_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';
import 'package:sizer/sizer.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String? languagename = CacheHelper.getData(key: "langname") ?? "Einglish";

  void _changeLanguage(Language languageee, ShopCubit shopCubit) async {
    Locale _locale = await setLocale(languageee.languageCode);
    MyApp.setLocale(context, _locale);

    String language = languageee.languageCode;
    CacheHelper.removeData(key: "langcode");
    CacheHelper.saveData(
      key: 'langcode',
      value: language,
    );
    if (language == "ar") {
      setState(() {
        languagename = "عربي";
        CacheHelper.removeData(key: "langname");
        CacheHelper.saveData(
          key: 'langname',
          value: languagename,
        );
      });
    } else {
      setState(() {
        languagename = "Einglish";
        CacheHelper.removeData(key: "langname");
        CacheHelper.saveData(
          key: 'langname',
          value: languagename,
        );
      });
    }
    shopCubit
      ..getHomeData()
      ..getCategoryData()
      ..getFavoriteData()
      ..getProfileData()
      ..getCartData()
      ..getAddresses();
  }

  //****************************************************************************
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        bool value = false;
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        getTranslated(context, "Ahlan_key")! +
                            cubit.userModel!.data!.name!
                                .split(' ')
                                .elementAt(0),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AutoSizeText(
                        '${cubit.userModel!.data!.email}',
                        style: TextStyle(fontSize: 13.sp),
                        minFontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: AutoSizeText(
                    getTranslated(context, "MY_ACCOUNT")!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                myDivider(),
                InkWell(
                  onTap: () {
                    navigateTo(
                      context,
                      AddressesScreen(),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(
                            context,
                            "Addresses_key",
                          )!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                myDivider(),
                InkWell(
                  onTap: () {
                    navigateTo(
                      context,
                      ProfileScreen(),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Profile_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                myDivider(),
                Container(
                  padding: EdgeInsets.all(15),
                  child: AutoSizeText(
                    getTranslated(
                      context,
                      "SETTINGS_key",
                    )!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Dark_Mode")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Switch(
                          value: value,
                          onChanged: (newValue) {
                            setState(() {
                              value = newValue;
                            });
                          },
                        ),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                myDivider(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Country_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        Spacer(),
                        AutoSizeText(
                          getTranslated(context, "Egypt_key")!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15.0.sp),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                        separator(10, 0),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                myDivider(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Language_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 0,
                            left: 0,
                          ),
                          child: DropdownButton<Language>(
                            underline: SizedBox(),
                            hint: AutoSizeText(
                              "         " + languagename!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15.0.sp),
                              maxLines: 1,
                              minFontSize: 10,
                            ),
                            iconSize: 25,
                            items: Language.languageList()
                                .map<DropdownMenuItem<Language>>(
                                  (e) => DropdownMenuItem<Language>(
                                    value: e,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          e.flag,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Text(e.name)
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (Language? language) {
                              _changeLanguage(language!, cubit);
                            },
                          ),
                        ),
                      ],
                    ),
                    /*Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Language_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        AutoSizeText('English'),
                        separator(10, 0),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),*/
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: AutoSizeText(
                    getTranslated(context, "REACH_OUT_TO_US")!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    ShopCubit.get(context).getFAQsData();
                    navigateTo(context, FAQsScreen());
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "FAQs_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                myDivider(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_in_talk_outlined,
                          color: Colors.green,
                        ),
                        separator(15, 0),
                        AutoSizeText(
                          getTranslated(context, "Contact_Us")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                        separator(10, 0),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  height: 60,
                  child: InkWell(
                    onTap: () {
                      signOut(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new),
                        SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          getTranslated(context, "SignOut_key")!,
                          style: TextStyle(fontSize: 15.sp),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
