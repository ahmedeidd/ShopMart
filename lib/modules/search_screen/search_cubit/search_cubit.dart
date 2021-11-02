import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matjar_app/models/searchModel/searchModel.dart';
import 'package:matjar_app/shard/app_and_shop_cubit/shop_states.dart';
import 'package:matjar_app/shard/components/constants.dart';
import 'package:matjar_app/shard/remote/dio_helper.dart';

class SearchCubit extends Cubit<ShopStates> {
  SearchCubit() : super(InitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void getSearchData(String searchText) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': '$searchText',
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      print('Search ' + searchModel!.status.toString());
      emit(SearchSuccessState());
    }).catchError((error) {
      emit(SearchErrorState());
      print(error.toString());
    });
  }
}
