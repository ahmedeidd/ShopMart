import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:matjar_app/layout/shop_layout_screen.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/homeModels/productModel.dart';
import 'package:matjar_app/modules/search_screen/search_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);

  PageController productImages = PageController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ProductDetailsData? model =
            ShopCubit.get(context).productDetailsModel?.data;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            titleSpacing: 0,
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
          body: state is ProductLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: AutoSizeText(
                                model!.name.toString(),
                                style: TextStyle(fontSize: 20.sp),
                                minFontSize: 15,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              height: 40.h,
                              width: double.infinity,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  PageView.builder(
                                    controller: productImages,
                                    itemCount: model.images!.length,
                                    itemBuilder: (context, index) => Image(
                                      image: NetworkImage(
                                        model.images![index],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ShopCubit.get(context)
                                          .changeToFavorite(model.id);
                                    },
                                    icon: Conditional.single(
                                      context: context,
                                      conditionBuilder: (context) =>
                                          ShopCubit.get(context)
                                              .favorites[model.id],
                                      widgetBuilder: (context) =>
                                          ShopCubit.get(context).favoriteIcon,
                                      fallbackBuilder: (context) =>
                                          ShopCubit.get(context).unFavoriteIcon,
                                    ),
                                    iconSize: 35,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            SmoothPageIndicator(
                              controller: productImages,
                              count: model.images!.length,
                              effect: ExpandingDotsEffect(
                                dotColor: Colors.grey,
                                activeDotColor: Colors.deepOrange,
                                expansionFactor: 4,
                                dotHeight: 7,
                                dotWidth: 10,
                                spacing: 10,
                              ),
                            ),
                            SizedBox(
                              height: 2.0.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  getTranslated(context, 'LE_key')! +
                                      model.price.toString(),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (model.discount != 0)
                                  Row(
                                    children: [
                                      AutoSizeText(
                                        getTranslated(context, 'LE_key')! +
                                            model.oldPrice.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.sp,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                        minFontSize: 10,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      AutoSizeText(
                                        model.discount.toString() + '% OFF',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.red,
                                        ),
                                        minFontSize: 10,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                myDivider(),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                AutoSizeText(
                                  getTranslated(context, "Offer_Details")!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      getTranslated(
                                        context,
                                        "1_Year_warranty",
                                      )!,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                myDivider(),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    AutoSizeText(
                                      getTranslated(
                                        context,
                                        "Sold_by_ShopMart",
                                      )!,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                myDivider(),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                AutoSizeText(
                                  getTranslated(context, "Overview_key")!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                AutoSizeText(
                                  model.description.toString(),
                                ),
                                SizedBox(
                                  height: 2.0.h,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 9.0.h,
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          if (ShopCubit.get(context).cart[model.id]) {
                            showToast(
                              msg: getTranslated(
                                context,
                                'Already_in_Your_Cart_Check_your_cart_To_Edit_or_Delete',
                              ),
                              state: ToastState.WARNING,
                            );
                          } else {
                            ShopCubit.get(context).addToCart(model.id);
                            scaffoldKey.currentState!.showBottomSheet(
                              (context) => Container(
                                color: Colors.grey[300],
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                model.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              AutoSizeText(
                                                getTranslated(
                                                  context,
                                                  "Added_to_Cart",
                                                )!,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 10,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.0.h),
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: AutoSizeText(
                                            getTranslated(
                                              context,
                                              'CONTINUE_SHOPPING',
                                            )!,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            navigateTo(
                                              context,
                                              ShopLayoutScreen(),
                                            );
                                            ShopCubit.get(context)
                                                .currentIndex = 3;
                                          },
                                          child: AutoSizeText(
                                            getTranslated(
                                              context,
                                              'CHECKOUT_key',
                                            )!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              elevation: 50,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined),
                            SizedBox(width: 1.0.w),
                            AutoSizeText(
                              getTranslated(context, "Add_to_Cart")!,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              minFontSize: 15,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
