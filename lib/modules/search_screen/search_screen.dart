import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/searchModel/searchModel.dart';
import 'package:matjar_app/modules/product_screen/product_screen.dart';
import 'package:matjar_app/modules/search_screen/search_cubit/search_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

TextEditingController searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  final ShopCubit? shopCubit;
  const SearchScreen({
    Key? key,
    this.shopCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              title: Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 250,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        controller: searchController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: getTranslated(
                            context,
                            "What_are_you_looking_for",
                          )!,
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.red,
                          ),
                        ),
                        onChanged: (value) {
                          cubit.getSearchData(value);
                        },
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        pop(context);
                      },
                      child: AutoSizeText(
                        getTranslated(context, "cancel_key")!,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: state is SearchLoadingState
                ? Center(child: CircularProgressIndicator())
                : cubit.searchModel != null
                    ? searchController.text.isEmpty
                        ? Container()
                        : ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => searchItemBuilder(
                              cubit.searchModel?.data.data[index],
                              shopCubit!,
                              context,
                            ),
                            separatorBuilder: (context, index) => myDivider(),
                            itemCount:
                                cubit.searchModel?.data.data.length ?? 10,
                          )
                    : Container(),
          );
        },
      ),
    );
  }

  //****************************************************************************
  Widget searchItemBuilder(
    SearchProduct? model,
    ShopCubit shopCubit,
    context,
  ) {
    return InkWell(
      onTap: () {
        shopCubit.getProductData(model!.id);
        navigateTo(
          context,
          ProductScreen(),
        );
      },
      child: Container(
        height: 110,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Image(
              image: NetworkImage('${model!.image}'),
              width: 150,
              height: 150,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  AutoSizeText(
                    '${model.name}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1,
                    ),
                    minFontSize: 10,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  AutoSizeText(
                    getTranslated(context, "LE_key")! + model.price.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
