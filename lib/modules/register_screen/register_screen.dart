import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/layout/shop_layout_screen.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/modules/register_screen/register_cubit/cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  var signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, ShopStates>(
        listener: (context, state) {
          if (state is SignUpSuccessState) if (state.signUpUserModel.status) {
            CacheHelper.saveData(
              key: 'token',
              value: state.signUpUserModel.data?.token,
            ).then((value) {
              token = state.signUpUserModel.data?.token;
              name.clear();
              phone.clear();
              email.clear();
              password.clear();
              confirmPassword.clear();
              navigateAndFinish(context, ShopLayoutScreen());
              ShopCubit.get(context).currentIndex = 0;
              ShopCubit.get(context).getHomeData();
              ShopCubit.get(context).getProfileData();
              ShopCubit.get(context).getFavoriteData();
              ShopCubit.get(context).getCartData();
              ShopCubit.get(context).getAddresses();
            });
          } else
            showToast(
              msg: state.signUpUserModel.message,
              state: ToastState.ERROR,
            );
        },
        builder: (context, state) {
          //RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 2,
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
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: signUpFormKey,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          getTranslated(
                            context,
                            "Create_ShopMart_account",
                          )!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0.sp,
                          ),
                          minFontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 3.0.h,
                        ),
                        defaultFormField(
                          context: context,
                          controller: name,
                          label: getTranslated(
                            context,
                            "Name_key",
                          )!,
                          prefix: Icons.person,
                          validate: (value) {
                            if (value!.isEmpty)
                              return getTranslated(
                                context,
                                "this_element_is_required",
                              )!;
                          },
                        ),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        defaultFormField(
                          context: context,
                          controller: phone,
                          label: getTranslated(
                            context,
                            "Phone_key",
                          )!,
                          keyboardType: TextInputType.phone,
                          prefix: Icons.phone,
                          validate: (value) {
                            if (value!.isEmpty)
                              return getTranslated(
                                context,
                                "this_element_is_required",
                              )!;
                          },
                        ),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        defaultFormField(
                          context: context,
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          label: getTranslated(
                            context,
                            "email_key",
                          )!,
                          prefix: Icons.email,
                          validate: (value) {
                            if (value!.isEmpty)
                              return getTranslated(
                                context,
                                "this_element_is_required",
                              )!;
                          },
                        ),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        defaultFormField(
                          context: context,
                          controller: password,
                          label: getTranslated(
                            context,
                            "password_key",
                          )!,
                          prefix: Icons.lock,
                          isPassword: RegisterCubit.get(context).showPassword
                              ? false
                              : true,
                          validate: (value) {
                            if (value!.isEmpty)
                              return getTranslated(
                                context,
                                "this_element_is_required",
                              )!;
                          },
                          onSubmit: (value) {},
                          suffix: RegisterCubit.get(context).suffixIcon,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changeSuffixIcon(context);
                          },
                        ),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        defaultFormField(
                          context: context,
                          controller: confirmPassword,
                          label: getTranslated(
                            context,
                            "Confirm_Password",
                          )!,
                          prefix: Icons.lock,
                          isPassword:
                              RegisterCubit.get(context).showConfirmPassword
                                  ? false
                                  : true,
                          validate: (value) {
                            if (value!.isEmpty)
                              return getTranslated(
                                context,
                                "this_element_is_required",
                              )!;
                            else if (value != password.text)
                              return getTranslated(
                                context,
                                "Password_Dont_Match",
                              )!;
                          },
                          suffix: RegisterCubit.get(context).confirmSuffixIcon,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changeConfirmSuffixIcon(context);
                          },
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        state is SignUpLoadingState
                            ? Center(child: CircularProgressIndicator())
                            : defaultButton(
                                onTap: () {
                                  if (signUpFormKey.currentState!.validate()) {
                                    RegisterCubit.get(context).signUp(
                                      name: name.text,
                                      phone: phone.text,
                                      email: email.text,
                                      password: password.text,
                                    );
                                  }
                                },
                                text: getTranslated(
                                  context,
                                  "SIGN_UP",
                                )!,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
