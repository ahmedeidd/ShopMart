import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/categoriesModels/categoriesModel.dart';
import 'package:matjar_app/models/homeModels/homeModel.dart';
import 'package:matjar_app/modules/category_products_screen/category_products_screen.dart';
import 'package:matjar_app/modules/product_screen/product_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.homeModel != null,
          widgetBuilder: (context) => productBuilder(
            cubit.homeModel,
            cubit.categoriesModel,
            context,
          ),
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  //****************************************************************************
  Widget productBuilder(
    HomeModel? homeModel,
    CategoriesModel? categoriesModel,
    context,
  ) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: homeModel!.data!.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage(e.image.toString()),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(seconds: 1),
                enableInfiniteScroll: true,
                height: 200,
                initialPage: 0,
                reverse: false,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
              ),
              carouselController: carouselController,
            ),
            Container(
              color: Colors.white,
              height: 140,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(start: 10, top: 10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => categoriesAvatar(
                  categoriesModel!.data!.data[index],
                  context,
                ),
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                itemCount: categoriesModel!.data!.data.length,
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: AutoSizeText(
                getTranslated(
                  context,
                  "Hot_Deals",
                )!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0.sp,
                  //fontSize: 20
                ),
                minFontSize: 10,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            separator(0, 1),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                homeModel.data!.products.length,
                (index) => productItemBuilder(
                  homeModel.data!.products[index],
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //****************************************************************************
  Widget categoriesAvatar(DataModel model, context) {
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getCategoriesDetailData(model.id);
        navigateTo(
          context,
          CategoryProductsScreen(
            categoryName: model.name,
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: defaultColor,
                radius: 36,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                child: Image(
                  image: NetworkImage(
                    model.image.toString(),
                  ),
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            model.name.toString(),
          ),
        ],
      ),
    );
  }

  //****************************************************************************
  Widget productItemBuilder(HomeProductModel model, context) {
    return InkWell(
      onTap: () {
        ShopCubit.get(context).getProductData(model.id);
        navigateTo(
          context,
          ProductScreen(),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsetsDirectional.only(start: 8, bottom: 8),
        child: Column(
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
              model.name.toString(),
              minFontSize: 10,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1),
            ),
            Spacer(),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    separator(0, 5),
                    if (model.discount != 0)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                Spacer(),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    ShopCubit.get(context).changeToFavorite(model.id);
                  },
                  icon: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        ShopCubit.get(context).favorites[model.id],
                    widgetBuilder: (context) =>
                        ShopCubit.get(context).favoriteIcon,
                    fallbackBuilder: (context) =>
                        ShopCubit.get(context).unFavoriteIcon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
