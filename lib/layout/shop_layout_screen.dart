import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/modules/search_screen/search_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ShopLayoutScreen extends StatefulWidget {
  const ShopLayoutScreen({Key? key}) : super(key: key);

  @override
  _ShopLayoutScreenState createState() => _ShopLayoutScreenState();
}

class _ShopLayoutScreenState extends State<ShopLayoutScreen> {
  bool showBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 2,
            title: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/ShopLogo.png'),
                  width: 50,
                  height: 50,
                ),
                AutoSizeText(
                  getTranslated(
                    context,
                    "Shop_Mart",
                  )!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0.sp,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(
                    context,
                    SearchScreen(
                      shopCubit: ShopCubit.get(context),
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          bottomSheet: showBottomSheet
              ? ShopCubit.get(context).cartModel.data!.cartItems.length != 0
                  ? Container(
                      width: double.infinity,
                      height: 60,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          getTranslated(
                            context,
                            "Check_Out",
                          )!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    )
              : Container(
                  width: 0,
                  height: 0,
                ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.navBar,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              if (index == 3) {
                showBottomSheet = true;
              } else if (ShopCubit.get(context)
                      .cartModel
                      .data!
                      .cartItems
                      .length ==
                  0) {
                showBottomSheet = false;
              } else {
                showBottomSheet = false;
              }
              return cubit.changeBottomNav(index);
            },
          ),
        );
      },
    );
  }
}
