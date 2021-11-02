import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matjar_app/modules/login_screen/login_screen.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_cubit.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';
import 'package:sizer/sizer.dart';

Widget defaultButton({
  required VoidCallback onTap,
  required String text,
  double? width = double.infinity,
}) =>
    Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: AutoSizeText(
          text,
          style: TextStyle(
            fontSize: 15.0.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 10,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

//******************************************************************************
Widget defaultFormField({
  required context,
  TextEditingController? controller,
  dynamic label,
  IconData? prefix,
  String? initialValue,
  TextInputType? keyboardType,
  Function(String)? onSubmit,
  onChange,
  onTap,
  required String? Function(String?) validate,
  bool isPassword = false,
  bool enabled = true,
  IconData? suffix,
  suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      textAlign: TextAlign.start,
      onFieldSubmitted: onSubmit,
      enabled: enabled,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      textCapitalization: TextCapitalization.words,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.bodyText1,
      initialValue: initialValue,
      //textCapitalization: TextCapitalization.words,

      decoration: InputDecoration(
        hintText: label,
        border: UnderlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
      ),
    );
//******************************************************************************
void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

//******************************************************************************
void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

//******************************************************************************
void pop(context) {
  Navigator.pop(context);
}

//******************************************************************************
enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}
Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.greenAccent;
      break;

    case ToastState.ERROR:
      color = Colors.redAccent;
      break;

    case ToastState.WARNING:
      color = Colors.orangeAccent;
      break;
  }
  return color;
}

void showToast({
  required String? msg,
  required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: msg!,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.white,
    textColor: chooseToastColor(state),
    fontSize: 14.0,
  );
}

//******************************************************************************

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    navigateAndFinish(context, LoginScreen());
    ShopCubit.get(context).currentIndex = 0;
  });
}

//******************************************************************************

void printFullText(String text) {
  final pattern = RegExp('.{1,800'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

//******************************************************************************

Widget myDivider() => Container(
      color: Colors.grey[300],
      height: 1,
      width: double.infinity,
    );

//******************************************************************************
Widget separator(double wide, double high) {
  return SizedBox(
    width: wide,
    height: high,
  );
}
//******************************************************************************

