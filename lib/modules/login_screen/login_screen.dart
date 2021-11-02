import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/layout/shop_layout_screen.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:matjar_app/modules/register_screen/register_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  var loginFormKey = GlobalKey<FormState>();
  get obscureText => null;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, ShopStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginUserModel.status) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginUserModel.data?.token,
              ).then((value) {
                token = state.loginUserModel.data?.token;
                navigateAndFinish(context, ShopLayoutScreen());
                emailController.clear();
                passwordController.clear();
                ShopCubit.get(context).currentIndex = 0;
                ShopCubit.get(context).getHomeData();
                ShopCubit.get(context).getProfileData();
                ShopCubit.get(context).getFavoriteData();
                ShopCubit.get(context).getCartData();
                ShopCubit.get(context).getAddresses();
              });
            } else {
              showToast(
                msg: state.loginUserModel.message,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          //LoginCubit cubit = LoginCubit.get(context);
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
            ),
            body: Center(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: loginFormKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            getTranslated(
                              context,
                              "Ahlan_Welcome_back",
                            )!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0.sp,
                            ),
                            minFontSize: 15,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: getTranslated(context, "Email_Address")!,
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
                            controller: passwordController,
                            label: getTranslated(
                              context,
                              "password_key",
                            )!,
                            prefix: Icons.lock,
                            isPassword: !LoginCubit.get(context).showPassword
                                ? true
                                : false,
                            validate: (value) {
                              if (value!.isEmpty)
                                return getTranslated(
                                  context,
                                  "this_element_is_required",
                                )!;
                            },
                            onSubmit: (value) {
                              if (loginFormKey.currentState!.validate()) {
                                LoginCubit.get(context).signIn(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            suffix: LoginCubit.get(context).suffixIcon,
                            suffixPressed: () {
                              LoginCubit.get(context).changeSuffixIcon(context);
                            },
                          ),
                          Container(
                            width: double.infinity,
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                getTranslated(
                                  context,
                                  "Forget_Your_Password",
                                )!,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5.h,
                          ),
                          state is! LoginLoadingState
                              ? defaultButton(
                                  onTap: () {
                                    if (loginFormKey.currentState!.validate()) {
                                      LoginCubit.get(context).signIn(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      token = CacheHelper.getData(key: 'token');
                                    }
                                  },
                                  text: getTranslated(context, "Login_key")!,
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                getTranslated(
                                    context, "Do_not_have_an_account")!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0.sp,
                                ),
                                minFontSize: 10,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: AutoSizeText(
                                  getTranslated(context, "Register_now")!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0.sp,
                                  ),
                                  minFontSize: 10,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
