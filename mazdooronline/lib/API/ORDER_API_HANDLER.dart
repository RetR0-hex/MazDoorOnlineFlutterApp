import 'package:mazdooronline/API/BILL_API_HANDLER.dart';
import 'API_HANDLER.dart';
import '/models/login_tokens.dart';
import 'package:dio/dio.dart';
import '/models/order.dart';

class OrderApiHandler extends APIHandler{
  Future<int> create_new_order(int category_id, String desc) async{
    try {
      Response response = await dio.post("/api/v1/orders/create-order/order",
      options: JWT_ACCESS_TOKEN_OPTIONS,
      data: {
        "category_id": category_id.toInt(),
        "desc": desc.toString(),
      });

      return response.data["order"]["id"];

    } catch (e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
    }
    return -1;
  }

  Future<bool> get_active_order_status() async{
    try {
      Response response = await dio.get("/api/v1/orders/active-orders/pending",
          options: JWT_ACCESS_TOKEN_OPTIONS);
      return response.data["isAccepted"];

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      return false;
    }
  }

  Future<bool> get_list_of_active_orders() async{
    try {
      Response response = await dio.get("/api/v1/orders/active-orders",
          options: JWT_ACCESS_TOKEN_OPTIONS);
      ActiveOrdersList active_orders = ActiveOrdersList();

      if (response.statusCode == 204){
        active_orders.flush_active_order_list();
        return true;
      }

      active_orders.flush_active_order_list();
      active_orders.add_active_orders_from_list(response.data["orders"]);
      return true;

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      return false;
    }
  }

  Future<OrderDetail> get_order_detail_by_id(int order_id) async {
    try {
      Response response = await dio.get("/api/v1/orders/get-order-by-id/order/${order_id.toString()}",
          options: JWT_ACCESS_TOKEN_OPTIONS);

      Response response2 = await dio.get("/api/v1/orders/get-location-by-id/order/${order_id.toString()}",
          options: JWT_ACCESS_TOKEN_OPTIONS);


      OrderDetail orderDetail = OrderDetail(
          id: response.data["order"]["id"],
          creator_id: response.data["order"]["creator_id"],
          category_id: response.data["order"]["category_id"],
          desc: response.data["order"]["desc"],
          category_name: response.data["order"]["category"]["name"],
          creator_name: response.data["order"]["creator"]["full_name"],
          creator_phone: response.data["order"]["creator"]["phone_number"],
          creator_email: response.data["order"]["creator"]["email"],
          creator_location_lat: response2.data["location"]["latitude"],
          creator_location_long: response2.data["location"]["longitude"],
          assigned_labor_id: response.data["order"]["assigned_labor_id"],
      );

      return orderDetail;

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      throw Exception("Error");
    }
  }

  Future<bool> accept_active_order_by_id(int id) async {
    try {
      Response response = await dio.post("/api/v1/orders/active-orders/order/accept",
          options: JWT_ACCESS_TOKEN_OPTIONS,
          data: {
            "order_id": id.toInt(),
          }
      );

      return true;

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      return false;
    }
  }

  Future<bool> complete_order_by_id(int order_id) async {
    try {
      Response response = await dio.get("/api/v1/orders/complete-order/order/${order_id.toString()}/",
          options: JWT_ACCESS_TOKEN_OPTIONS,
      );

      return true;

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      return false;
    }
  }


  Future<bool> check_order_completion_status(int order_id) async {
    try {
      Response response = await dio.get("/api/v1/orders/check-complete-order/order/${order_id.toString()}",
          options: JWT_ACCESS_TOKEN_OPTIONS,
      );

      bool billGenerationStatus = await BillApiHandler().get_bill_generation_status(order_id);

      return (response.data["is_completed"] && billGenerationStatus);

    } catch(e){
      if (e is DioError){
        throw Exception(e.response?.data["error"]);
      }
      return false;
    }
  }
}