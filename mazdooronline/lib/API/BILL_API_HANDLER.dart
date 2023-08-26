import 'package:flutter/cupertino.dart';
import 'API_HANDLER.dart';
import 'package:dio/dio.dart';
import '/models/bill.dart';


class BillApiHandler extends APIHandler {
    Future<bool> create_bill(int order_id) async {
      try {
        Response response = await dio.post("/api/v1/bills/create-bill",
            options: JWT_ACCESS_TOKEN_OPTIONS,
            data: {
              "order_id": order_id.toInt(),
            }
        );


        BillData billData = BillData();

        billData.update_bill(
            response.data["bill"]["id"],
            response.data["bill"]["amount"],
            response.data["bill"]["base_rate"],
            response.data["bill"]["hours"],
            response.data["bill"]["minutes"],
        );


        return true;

      } catch(e){
        if (e is DioError){
          throw Exception(e.response?.data["error"]);
        }
        return false;
      }
    }

    Future<bool> payment_completed(int bill_id) async {
      try {
        Response response = await dio.get("/api/v1/bills/pay-bill-by-id/bill/${bill_id.toString()}",
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

    Future<bool> get_bill_generation_status(int order_id) async{
      try {
        Response response = await dio.get("/api/v1/bills/get-bill-by-order-id/bill/${order_id.toString()}",
            options: JWT_ACCESS_TOKEN_OPTIONS,
        );

        if (response.statusCode == 200){
          return true;
        }

        return false;

      } catch(e){
        if (e is DioError){
          throw Exception(e.response?.data["error"]);
        }
        return false;
      }
    }

    Future<bool> check_bill_payment_status(int bill_id) async {
      try {
        Response response = await dio.get("/api/v1/bills/check-bill-payment/bill/${bill_id.toString()}",
          options: JWT_ACCESS_TOKEN_OPTIONS,
        );

        return response.data["is_payment"];

      } catch(e){
        if (e is DioError){
          throw Exception(e.response?.data["error"]);
        }
        return false;
      }
    }

    Future<bool> get_bill_data(int order_id) async{
      try {
        Response response = await dio.get("/api/v1/bills/get-bill-by-order-id/bill/${order_id.toString()}",
            options: JWT_ACCESS_TOKEN_OPTIONS,
        );

        BillData billData = BillData();

        billData.update_bill(
          response.data["bill"]["id"],
          response.data["bill"]["amount"],
          response.data["bill"]["base_rate"],
          response.data["bill"]["hours"],
          response.data["bill"]["minutes"],
        );

        return true;

      } catch(e){
        if (e is DioError){
          throw Exception(e.response?.data["error"]);
        }
        return false;
      }
    }
}