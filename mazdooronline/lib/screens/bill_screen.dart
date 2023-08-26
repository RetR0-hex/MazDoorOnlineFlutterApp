import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mazdooronline/API/REVIEW_API_HANDLER.dart';
import '/components/custom_button.dart';
import '/constants.dart';
import 'package:intl/intl.dart';
import '/models/bill.dart';
import '/models/order.dart';
import '../API/BILL_API_HANDLER.dart';
import '../components/homescreen/circular_loader.dart';
import '../components/slider_button.dart';

final currencyFormatter = NumberFormat('##,##,##0.0');

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  bool isPaid = false;
  late Future<bool> bill_data_future;
  BillData billData = BillData();
  Timer? payment_status_timer;

  void initState() {
    // TODO: implement initState
    super.initState();
    getBillData();
    payment_status_timer =
        Timer.periodic(Duration(seconds: 7), (Timer t) => checkPaymentStatus());
  }

  void getBillData() async {
    BillApiHandler api = BillApiHandler();
    bill_data_future =
        api.get_bill_data(CurrentActiveOrder().order.id); // change
  }

  void checkPaymentStatus() async {
    BillApiHandler api = BillApiHandler();
    bool status = await api.check_bill_payment_status(BillData().id);
    if (status) {
      setState(() {
        isPaid = true;
      });
      payment_status_timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
          child: FutureBuilder<bool>(
              future: bill_data_future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Container(
                            key: ValueKey<bool>(isPaid),
                            child: Icon(
                              !isPaid
                                  ? Icons.info_rounded
                                  : Icons.check_circle_rounded,
                              color: !isPaid ? Colors.orange : Colors.green,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            key: ValueKey<bool>(isPaid),
                            !isPaid
                                ? 'Waiting for Payment...'
                                : 'Payment Successful!',
                            textAlign: TextAlign.center,
                            style: kPopularOptionsPillTextStyle,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'PKR. ${currencyFormatter.format(billData.amount)}',
                          textAlign: TextAlign.center,
                          style: kHeadTextStyle.copyWith(
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1,
                          height: 25,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Ref number: ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 3,
                                child: Text(
                                  billData.id.toString(),
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Order ID: ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 3,
                                child: Text(
                                  "11",
                                  //CurrentActiveOrder().order.id.toString(),
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Completion Time: ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 2,
                                child: Text(
                                  DateFormat().format(DateTime.now()),
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Total Time (HH:MM): ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 4,
                                child: Text(
                                  "${billData.hours.toString().padLeft(2, '0')}:${billData.minutes.toString().padLeft(2, '0')}",
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Rate/hr: ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 4,
                                child: Text(
                                  "Rs. ${billData.base_rate.toString()}",
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Payment Method: ",
                                  style: kPopularOptionsPillTextStyle.copyWith(
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: Text(
                                  "Cash",
                                  style: kHeadTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Container(
                              key: ValueKey<bool>(isPaid),
                              child: !isPaid
                                  ? SlideActionBtn(
                                      onSlide: () {},
                                      label: "Waiting for payment...")
                                  : CustomButton(
                                      buttonColor: Colors.blue,
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                SingleChildScrollView(
                                                    child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: ReviewScreen(),
                                                )));

                                      },
                                      buttonText: "Give Feedback"),
                            )),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularLoader(),
                );
              }),
        ));
  }
}

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Expanded(
            child: Text(
              "Rate your experience \nof this job",
              style: kHeadTextStyle.copyWith(fontSize: 26),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) async {
                ReviewApiHandler api = ReviewApiHandler();
                await api.create_review(CurrentActiveOrder().order.id, rating.toInt());
                 Navigator.pushNamedAndRemoveUntil(context, '/home',
                         (Route<dynamic> route) => false);;
              },
            ),
          ),
        ],
      ),
    );
  }
}
