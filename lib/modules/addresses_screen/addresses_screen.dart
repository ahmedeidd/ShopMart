import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/models/addressModels/addressModel.dart';
import 'package:matjar_app/modules/search_screen/search_screen.dart';
import 'package:matjar_app/modules/update_address_screen/update_address_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

TextEditingController cityController = TextEditingController();
TextEditingController regionController = TextEditingController();
TextEditingController detailsController = TextEditingController();
TextEditingController notesController = TextEditingController();

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

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
                  image: AssetImage(
                    'assets/images/ShopLogo.png',
                  ),
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
          bottomSheet: Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: MaterialButton(
              onPressed: () {
                navigateTo(
                  context,
                  UpdateAddressScreen(
                    isEdit: false,
                  ),
                );
              },
              color: Colors.deepOrange,
              child: AutoSizeText(
                getTranslated(context, "ADD_A_NEW_ADDRESS")!,
                style: TextStyle(
                  fontSize: 17.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                minFontSize: 15,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      ShopCubit.get(context).addressModel.data!.data!.length ==
                              0
                          ? Container()
                          : addressItem(
                              ShopCubit.get(context)
                                  .addressModel
                                  .data!
                                  .data![index],
                              context,
                            ),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount:
                      ShopCubit.get(context).addressModel.data!.data!.length,
                ),
                Container(
                  color: Colors.white,
                  height: 70,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //****************************************************************************
  Widget addressItem(AddressData model, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.green,
              ),
              SizedBox(
                width: 5,
              ),
              AutoSizeText(
                '${model.name}',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 15,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    ShopCubit.get(context).deleteAddress(addressId: model.id);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 17,
                      ),
                      Text(
                        getTranslated(context, "Delete_key")!,
                      ),
                    ],
                  )),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey[300],
              ),
              TextButton(
                  onPressed: () {
                    navigateTo(
                        context,
                        UpdateAddressScreen(
                          isEdit: true,
                          addressId: model.id,
                          name: model.name,
                          city: model.city,
                          region: model.region,
                          details: model.details,
                          notes: model.notes,
                        ));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Colors.grey,
                      ),
                      Text(
                        getTranslated(context, "Edit_key")!,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
            ],
          ),
        ),
        myDivider(),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      getTranslated(context, "City_key")!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Region_key")!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Details_key")!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Notes_key")!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '${model.city}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    '${model.region}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    '${model.details}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    '${model.notes}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
