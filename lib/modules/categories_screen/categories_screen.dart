import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/models/categoriesModels/categoriesModel.dart';
import 'package:matjar_app/modules/category_products_screen/category_products_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => buildCategoriesItem(
            ShopCubit.get(context).categoriesModel!.data!.data[index],
            context,
          ),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: ShopCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }
  //****************************************************************************

  Widget buildCategoriesItem(DataModel model, context) {
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
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Image(
              image: NetworkImage('${model.image}'),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            separator(15, 0),
            AutoSizeText(
              '${model.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
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
    );
  }
}
