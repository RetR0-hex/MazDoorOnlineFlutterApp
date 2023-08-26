import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BillData with ChangeNotifier{

  static final BillData _singleton = BillData._internal();

  late int amount;
  late double base_rate;
  late int hours;
  late int minutes;
  late int id;
  //late String created_at;
  //late int order_id;

  factory BillData() {
    return _singleton;
  }

  BillData._internal();

  void update_bill(int id, int amount, double baseRate, int hours, int minutes){ //String createdAt, int orderId){
    this.id = id;
    this.amount = amount;
    this.base_rate = baseRate;
    this.hours = hours;
    this.minutes = minutes;
    //this.created_at = createdAt;
    //this.order_id = orderId;
    notifyListeners();
  }
}