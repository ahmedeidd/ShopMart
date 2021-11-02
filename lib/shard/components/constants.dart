import 'package:flutter/material.dart';
import 'package:matjar_app/models/language.dart';
import 'package:matjar_app/shard/local/cache_helper.dart';

const LOGIN = 'login';

const SIGNUP = 'register';

const PROFILE = 'profile';

const UPDATE_PROFILE = 'update-profile';

const HOME = 'home';

const CATEGORIES = 'categories';

const CATEGORIES_DETAIL = 'products';

const PRODUCT_DETAILS = 'products/1';

const SEARCH = 'products/search';

const FAVORITES = 'favorites';

const CART = 'carts';

String? token = '';
bool isArabic = false;
//String? language = isArabic == true ? 'ar' : 'en';

//String? language = CacheHelper.getData(key: 'langcode') ?? 'en';

bool? isDark = false;

Color defaultColor = Colors.red;

int cartLength = 0;
