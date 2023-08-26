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
          print(e.response?.data["error"]);
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
}