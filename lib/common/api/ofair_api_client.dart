

import 'package:dio/dio.dart';



class OfairApiClient{
  Dio getDio()  {
    Dio dio = Dio();
    dio.options.baseUrl = 'https://cafecardapi.onrender.com/';
    return dio;
  }
}