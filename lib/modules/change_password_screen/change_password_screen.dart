import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

TextEditingController currentPass = TextEditingController();
TextEditingController newPass = TextEditingController();
var changePasskey = GlobalKey<FormState>();

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                Text(
                  getTranslated(
                    context,
                    "Shop_Mart",
                  )!,
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
          body: Container(
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Form(
              key: changePasskey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is ChangePassLoadingState)
                    Column(
                      children: [
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  AutoSizeText(
                    getTranslated(context, "Current_Password")!,
                    style: TextStyle(fontSize: 13.sp),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextFormField(
                    controller: currentPass,
                    textCapitalization: TextCapitalization.words,
                    obscureText: ShopCubit.get(context).showCurrentPassword
                        ? true
                        : false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: getTranslated(
                        context,
                        "Please_enter_Current_Password",
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeCurrentPassIcon(context);
                        },
                        icon: Icon(ShopCubit.get(context).currentPasswordIcon),
                      ),
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
                    height: 5.0.h,
                  ),
                  AutoSizeText(
                    'New Password',
                    style: TextStyle(fontSize: 13.sp),
                    minFontSize: 10,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextFormField(
                    controller: newPass,
                    textCapitalization: TextCapitalization.words,
                    obscureText:
                        !ShopCubit.get(context).showNewPassword ? true : false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: getTranslated(
                        context,
                        "Please_enter_New_Password",
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeNewPassIcon(context);
                        },
                        icon: Icon(ShopCubit.get(context).newPasswordIcon),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return getTranslated(
                          context,
                          "This_field_cant_be_Empty",
                        );
                    },
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (changePasskey.currentState!.validate()) {
                          ShopCubit.get(context).changePassword(
                            context: context,
                            currentPass: currentPass.text,
                            newPass: newPass.text,
                          );
                        }
                      },
                      child: AutoSizeText(
                        getTranslated(context, "Change_Password")!,
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
}
