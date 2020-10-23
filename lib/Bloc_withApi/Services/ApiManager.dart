import 'dart:convert';

import 'package:flutteradvanced/Bloc_withApi/Models/NewsApiModel.dart';
import 'package:flutteradvanced/Bloc_withApi/constant/strings.dart';
import 'package:http/http.dart' as http;
class API_Manager{
  Future<NewsApi> getNews() async{
    var client = http.Client();
    var newsModel;
    try{
      var response = await client.get(Strings.news_url);
      if(response.statusCode == 200){
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);
        newsModel = NewsApi.fromJson(jsonMap);

      }
    }catch(Exception){
      return newsModel;
    }
    return newsModel;
  }
}