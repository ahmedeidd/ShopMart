import 'package:dio/dio.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';

class DioHelper {
  static Dio? dio;
  static dioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  //****************************************************************************
  static Future<Response<dynamic>> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    String? localToken = token;
    String langeee = CacheHelper.getData(key: 'langcode') ?? "en";
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': localToken == null ? '' : localToken,
      'lang': langeee,
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  //****************************************************************************

  static Future<Response<dynamic>> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    //String lang = 'en',
    String? token,
  }) async {
    String langeee = CacheHelper.getData(key: 'langcode') ?? "en";
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': langeee,
      'Authorization': token != null ? token : '',
    };
    return await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  //****************************************************************************

  static Future<Response<dynamic>> putData({
    required String url,
    Map<String, dynamic>? query,
    //String lang = 'en',
    String? token,
    required Map<String, dynamic> data,
  }) async {
    String langeee = CacheHelper.getData(key: 'langcode') ?? "en";
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': langeee,
      'Authorization': token != null ? token : '',
    };
    return await dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
  }

  //****************************************************************************
  static Future<Response> deleteData({
    required String url,
    //String lang = 'en',
    String? token,
  }) async {
    String langeee = CacheHelper.getData(key: 'langcode') ?? "en";
    dio!.options.headers = {
      'lang': langeee,
      'Content-Type': 'application/json',
      'Authorization': '$token'
    };
    return await dio!.delete(url);
  }
  //****************************************************************************
}
