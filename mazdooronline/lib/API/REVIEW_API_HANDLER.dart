

import 'package:dio/dio.dart';

import 'API_HANDLER.dart';

class ReviewApiHandler extends APIHandler {
  Future<bool> create_review(int order_id, int rating) async {
    try {
      Response response = await dio.put("/api/v1/reviews/give-review/review/",
          options: JWT_ACCESS_TOKEN_OPTIONS,
          data: {
            "order_id": order_id.toInt(),
            "review_val": rating.toInt(),
          }
      );

          return true;
    } catch (e)
      {
        if (e is DioError) {
          throw Exception(e.response?.data["error"]);
        }
      }
      return false;
    }
}