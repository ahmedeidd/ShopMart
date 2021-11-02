import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/categoriesModels/categoriesDetailsModel.dart';
import 'package:matjar_app/modules/product_screen/product_screen.dart';
import 'package:matjar_app/modules/search_screen/search_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:sizer/sizer.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String? categoryName;
  const CategoryProductsScreen({
    Key? key,
    this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
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
          body: state is CategoryDetailsLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ShopCubit.get(context)
                          .categoriesDetailModel!
                          .data
                          .productData
                          .length ==
                      0
                  ? Center(
                      child: AutoSizeText(
                        getTranslated(context, "Coming_Soon")!,
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                        ),
                        minFontSize: 20,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        color: Colors.grey[300],
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              padding: EdgeInsets.all(15),
                              child: AutoSizeText(
                                '$categoryName',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: 15,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            separator(0, 1),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 2,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 2,
                              children: List.generate(
                                ShopCubit.get(context)
                                    .categoriesDetailModel!
                                    .data
                                    .productData
                                    .length,
                                (index) => ShopCubit.get(context)
                                            .categoriesDetailModel!
                                            .data
                                            .productData
                                            .length ==
                                        0
                                    ? Center(
                                        child: AutoSizeText(
                                          getTranslated(
                                              context, "Coming_Soon")!,
                                          style: TextStyle(
                                            fontSize: 30.sp,
                                            color: Colors.white,
                                          ),
                                          minFontSize: 20,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : productItemBuilder(
                                        ShopCubit.get(context)
                                            .categoriesDetailModel!
                                            .data
                                            .productData[index],
                                        context,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  //****************************************************************************
  Widget productItemBuilder(ProductData model, context) {
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getProductData(model.id);
        navigateTo(context, ProductScreen());
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsetsDirectional.only(
          start: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  height: 150,
                  width: 150,
                  image: NetworkImage(
                    model.image.toString(),
                  ),
                ),
                if (model.discount != 0)
                  Container(
                    color: defaultColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AutoSizeText(
                        getTranslated(context, "DISCOUNT_key")!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            separator(0, 10),
            AutoSizeText(
              '${model.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1),
            ),
            Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          getTranslated(context, "LE_key")!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 11.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          model.price.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    separator(0, 5),
                    if (model.discount != 0)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            getTranslated(context, "LE_key")!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.sp,
                              decoration: TextDecoration.lineThrough,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AutoSizeText(
                            model.oldPrice.toString(),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          separator(5, 0),
                          AutoSizeText(
                            model.discount.toString() +
                                '%' +
                                getTranslated(
                                  context,
                                  'OFF_key',
                                )!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11.sp,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
