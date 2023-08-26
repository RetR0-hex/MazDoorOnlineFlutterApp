import 'package:flutter/cupertino.dart';
import 'API_HANDLER.dart';
import 'package:dio/dio.dart';
import '/models/categories.dart';


class CategoryApiHandler extends APIHandler{

  Future<bool> get_categories(List<AssetImage> icons) async{
      try {
        Response response = await dio.get('/api/v1/categories');
        Categories cat = Categories();
        cat.flush_category_list();
        cat.add_category_from_list(response.data["categories"], icons);

      } catch (e){
        if (e is DioError){
          throw Exception(e.response?.data['msg']);
        }
      }

      return true;
    }
}