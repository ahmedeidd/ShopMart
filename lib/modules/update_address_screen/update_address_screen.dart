import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

TextEditingController nameControl = TextEditingController();
TextEditingController cityControl = TextEditingController();
TextEditingController regionControl = TextEditingController();
TextEditingController detailsControl = TextEditingController();
TextEditingController notesControl = TextEditingController();
var addressFormKey = GlobalKey<FormState>();

class UpdateAddressScreen extends StatelessWidget {
  final bool isEdit;
  final int? addressId;
  final String? name;
  final String? city;
  final String? region;
  final String? details;
  final String? notes;

  const UpdateAddressScreen({
    Key? key,
    required this.isEdit,
    this.addressId,
    this.name,
    this.city,
    this.region,
    this.details,
    this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is UpdateAddressSuccessState) {
          if (state.updateAddressModel.status) pop(context);
        } else if (state is AddAddressSuccessState) {
          if (state.addAddressModel.status) pop(context);
        }
      },
      builder: (context, state) {
        if (isEdit) {
          nameControl.text = name!;
          cityControl.text = city!;
          regionControl.text = region!;
          detailsControl.text = details!;
          notesControl.text = notes!;
        }
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
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
              TextButton(
                onPressed: () {
                  pop(context);
                },
                child: AutoSizeText(
                  getTranslated(context, "cancel_key")!,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: addressFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is AddAddressLoadingState ||
                        state is UpdateAddressLoadingState)
                      Column(
                        children: [
                          LinearProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    AutoSizeText(
                      getTranslated(context, "LOCATION_INFORMATION")!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Name_key")!,
                      style: TextStyle(fontSize: 12.sp),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      controller: nameControl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                          context,
                          "Please_enter_your_Location_name",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return getTranslated(
                            context,
                            "This_field_cant_be_Empty",
                          );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      getTranslated(context, "City_key")!,
                      style: TextStyle(fontSize: 12.sp),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      controller: cityControl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                          context,
                          "Please_enter_your_City_name",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return getTranslated(
                            context,
                            "This_field_cant_be_Empty",
                          );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Region_key")!,
                      style: TextStyle(fontSize: 12.sp),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      controller: regionControl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                          context,
                          "Please_enter_your_region",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return getTranslated(
                            context,
                            "This_field_cant_be_Empty",
                          );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Details_key")!,
                      style: TextStyle(fontSize: 12.sp),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      controller: detailsControl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                          context,
                          "Please_enter_some_details",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return getTranslated(
                            context,
                            "This_field_cant_be_Empty",
                          );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AutoSizeText(
                      getTranslated(context, "Notes_key")!,
                      style: TextStyle(fontSize: 12.sp),
                      minFontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextFormField(
                      controller: notesControl,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                          context,
                          "Please_add_some_notes_to_help_find_you",
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return getTranslated(
                            context,
                            "This_field_cant_be_Empty",
                          );
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (addressFormKey.currentState!.validate()) {
                            if (isEdit) {
                              ShopCubit.get(context).updateAddress(
                                  addressId: addressId,
                                  name: nameControl.text,
                                  city: cityControl.text,
                                  region: regionControl.text,
                                  details: detailsControl.text,
                                  notes: notesControl.text);
                            } else {
                              ShopCubit.get(context).addAddress(
                                  name: nameControl.text,
                                  city: cityControl.text,
                                  region: regionControl.text,
                                  details: detailsControl.text,
                                  notes: notesControl.text);
                            }
                          }
                        },
                        child: AutoSizeText(
                          getTranslated(
                            context,
                            "SAVE_ADDRESS",
                          )!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
