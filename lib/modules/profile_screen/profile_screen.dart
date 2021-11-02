import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/localization/language_constants.dart';
import 'package:matjar_app/modules/change_password_screen/change_password_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/components.dart';
import 'package:sizer/sizer.dart';

TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isEdit = false;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String editText = getTranslated(context, "Edit_key")!;
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) if (state
            .updateUserModel.status)
          showToast(
            msg: state.updateUserModel.message,
            state: ToastState.SUCCESS,
          );
        else
          showToast(
            msg: state.updateUserModel.message,
            state: ToastState.ERROR,
          );
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        var model = cubit.userModel;
        nameController.text = model!.data!.name!;
        phoneController.text = model.data!.phone!;

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
                  minFontSize: 10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          getTranslated(context, "Ahlan_key")! +
                              cubit.userModel!.data!.name!
                                  .split(' ')
                                  .elementAt(0),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          '${cubit.userModel!.data!.email}',
                          style: TextStyle(fontSize: 13.sp),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 280,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state is UpdateProfileLoadingState)
                          Column(
                            children: [
                              LinearProgressIndicator(),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            AutoSizeText(
                              getTranslated(context, "PERSONAL_INFORMATION")!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                isEdit = !isEdit;
                                if (isEdit) {
                                  editText =
                                      getTranslated(context, "Save_key")!;
                                  ShopCubit.get(context)
                                      .emit(EditPressedState());
                                } else {
                                  editText =
                                      getTranslated(context, "Edit_key")!;
                                  ShopCubit.get(context).updateProfileData(
                                    email:
                                        cubit.userModel!.data!.email.toString(),
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '$editText',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        AutoSizeText(
                          getTranslated(context, "Name_key")!,
                          style: TextStyle(fontSize: 13.sp),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        defaultFormField(
                          controller: nameController,
                          context: context,
                          prefix: Icons.person,
                          enabled: isEdit ? true : false,
                          validate: (value) {},
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        AutoSizeText(
                          getTranslated(context, "Phone_key")!,
                          style: TextStyle(fontSize: 13.sp),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        defaultFormField(
                          context: context,
                          controller: phoneController,
                          prefix: Icons.phone,
                          enabled: isEdit ? true : false,
                          validate: (value) {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          getTranslated(context, "SECURITY_INFORMATION")!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            navigateTo(
                              context,
                              ChangePasswordScreen(),
                            );
                          },
                          child: AutoSizeText(
                            getTranslated(context, "Change_Password")!,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
