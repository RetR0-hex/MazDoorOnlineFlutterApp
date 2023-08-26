import 'dart:io';

import 'package:flutter/cupertino.dart';

class Order {
  late int id;
  late int category_id;
  late int creator_id;
  late String desc;
  late String category_name;

  Order({required this.id, required this.creator_id,
    required this.category_id, required this.desc, required this.category_name});


}

class OrderDetail extends Order{
  late String creator_name;
  late String creator_phone;
  late String creator_email;
  late double creator_location_lat;
  late double creator_location_long;
  late int? assigned_labor_id;

  OrderDetail({required super.id,
    required super.creator_id,
    required super.category_id,
    required super.desc,
    required super.category_name,
    required this.creator_name,
    required this.creator_phone,
    required this.creator_email,
    required this.creator_location_lat,
    required this.creator_location_long,
    required this.assigned_labor_id,
  });
}

class CurrentActiveOrder with ChangeNotifier{

  static final CurrentActiveOrder _singleton = CurrentActiveOrder._internal();
  late OrderDetail order;

  factory CurrentActiveOrder() {
    return _singleton;
  }

  CurrentActiveOrder._internal();

  void add_order(OrderDetail order_){
    order = order_;
    notifyListeners();
  }
}

class ActiveOrdersList with ChangeNotifier{
  static final ActiveOrdersList _singleton = ActiveOrdersList._internal();
  List<Order> active_orders = [];

  factory ActiveOrdersList() {
    return _singleton;
  }

  ActiveOrdersList._internal();

  void add_active_order(id, category_id, creator_id, desc, category_name){
    active_orders.add(Order(id:id, category_id: category_id, creator_id: creator_id, desc: desc, category_name: category_name));
  }

  void flush_active_order_list(){
    active_orders.clear();
  }

  void add_active_orders_from_list(List json){
    // add a list of orders to the active_orders list
    int i = 0;
    while(i < json.length){
      add_active_order(json[i]["id"], json[i]["category_id"],
          json[i]["creator_id"], json[i]["desc"], json[i]["category"]["name"]);
      i++;
    }
    notifyListeners();
  }
}

