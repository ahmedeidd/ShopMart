import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/profileModels/faqsModels.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
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
                  minFontSize: 15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          body: state is FAQsLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey[300],
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: AutoSizeText(
                          getTranslated(context, "FAQs_key")!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => faqsItemBuilder(
                          cubit.faqsModel.data!.data![index],
                        ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: cubit.faqsModel.data!.data!.length,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  //****************************************************************************
  Widget faqsItemBuilder(FAQsData model) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            '${model.question}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
            ),
            minFontSize: 10,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 15,
          ),
          AutoSizeText(
            '${model.answer}',
            style: TextStyle(fontSize: 12.sp),
            minFontSize: 10,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
