import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Category {
  final int id;
  final String name;
  final int baseRate;

  bool isSelected = false;

  Category({required this.id, required this.name,
            required this.baseRate});
}


class Categories with ChangeNotifier {

  static final Categories _singleton = Categories._internal();

  List<Category> categories = [];

  factory Categories() {
    return _singleton;
  }

  Categories._internal();

  void add_category(int id, String name, int baseRate){
    categories.add(Category(id: id, name: name, baseRate: baseRate));
  }

  void add_category_from_list(List json){
    int i = 0;
    while(i < json.length){
        add_category(json[i]["id"], json[i]["name"],
            json[i]["base_rate_per_hour"]);
        i++;
    }
    notifyListeners();
  }

  void flush_category_list(){
    categories.clear();
  }

  void isSelectedFalse(){
    for (int i = 0; i < categories.length; i++){
      categories[i].isSelected = false;
    }
    notifyListeners();
  }

  void changeValueisSelected(int index){
    categories[index].isSelected = !categories[index].isSelected;
    notifyListeners();
  }

  String getCategoryName(int category_id){
    for (int i = 0; i < categories.length; i++){
      if (categories[i].id == category_id){
        return categories[i].name;
      }
    }
    return "Category not found";
  }

  int getCategoryBaseRate(int category_id){
    for (int i = 0; i < categories.length; i++){
      if (categories[i].id == category_id){
        return categories[i].baseRate;
      }
    }
    return 0;
  }

}