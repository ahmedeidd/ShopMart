import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/favoritesModels/favoritesModel.dart';
import 'package:matjar_app/modules/product_screen/product_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Conditional.single(
            context: context,
            conditionBuilder: (context) => state is! FavoritesLoadingState,
            widgetBuilder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        AutoSizeText(
                          getTranslated(context, "My_Wishlist")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                          minFontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        AutoSizeText(
                          "(${ShopCubit.get(context).favoritesModel!.data.total} ${getTranslated(context, 'items_key')})",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => favoriteProducts(
                        ShopCubit.get(context)
                            .favoritesModel!
                            .data
                            .data[index]
                            .product,
                        context),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount:
                        ShopCubit.get(context).favoritesModel!.data.data.length,
                  ),
                ],
              ),
            ),
            fallbackBuilder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  //****************************************************************************
  Widget favoriteProducts(FavoriteProduct? model, context) {
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getProductData(model!.id);
        navigateTo(
          context,
          ProductScreen(),
        );
      },
      child: Container(
        height: 26.h,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Container(
              height: 14.h,
              child: Row(
                children: [
                  Image(
                    width: 150,
                    height: 150,
                    image: NetworkImage(
                      model!.image.toString(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          model.name.toString(),
                          minFontSize: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        AutoSizeText(
                          getTranslated(context, "LE_key")! +
                              model.price.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (model.discount != 0)
                          AutoSizeText(
                            getTranslated(context, "LE_key")! +
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Spacer(),
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).addToCart(model.id);
                    },
                    child: AutoSizeText(
                      getTranslated(context, "Add_to_Cart")!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      ShopCubit.get(context).changeToFavorite(model.id);
                      ShopCubit.get(context).getFavoriteData();
                    },
                    child: AutoSizeText(
                      getTranslated(context, "Remove_key")!,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
