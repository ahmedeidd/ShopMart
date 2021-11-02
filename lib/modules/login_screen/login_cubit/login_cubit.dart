import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/models/profileModels/userModel.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:matjar_app/shard/remote/dio_helper.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<ShopStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? loginModel;
  void signIn({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      token: token,
      data: {
        'email': '$email',
        'password': '$password',
      },
    ).then((value) {
      loginModel = UserModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState());
    });
  }
  //****************************************************************************

  bool showPassword = false;
  IconData suffixIcon = Icons.visibility;
  void changeSuffixIcon(context) {
    showPassword = !showPassword;
    if (showPassword)
      suffixIcon = Icons.visibility_off;
    else
      suffixIcon = Icons.visibility;
    emit(ChangeSuffixIconState());
  }
}
