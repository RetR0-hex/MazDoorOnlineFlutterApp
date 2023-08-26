import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/categories.dart';
import '/components/appbar.dart';
import '/constants.dart';
import '/components/divider.dart';
import '/components/custom_button.dart';
import '/components/password_show.dart';
import '/API/USER_API_HANDLER.dart';
import '/API/CATEGORY_API_HANDLER.dart';
import "/components/homescreen/circular_loader.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignupScreen> {
  String email = "";
  String password = "";
  String name = "";
  String phone_number = "";
  bool showError = false;
  bool _passvisible = false;
  int selected_category_id = 1;
  bool is_loading = false;

  late Future<bool> category_data_status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoriesData();
  }

  void getCategoriesData() async {
    CategoryApiHandler api = CategoryApiHandler();
    category_data_status = api.get_categories();
  }

  void changepasswordstate() {
    setState(() {
      _passvisible = !_passvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: category_data_status,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return CustomAppBar(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                        child: Text('Sign up', style: kLoginScreenTextStyle)),
                    SizedBox(
                      height: 24,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                      decoration: kInputBoxDecoration.copyWith(
                        hintText: "Email ID",
                        icon: Icon(Icons.alternate_email),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        //Do something with the user input.
                        name = value;
                      },
                      decoration: kInputBoxDecoration.copyWith(
                        hintText: "Full name",
                        icon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        //Do something with the user input.
                        phone_number = value;
                      },
                      decoration: kInputBoxDecoration.copyWith(
                        hintText: "Phone number",
                        icon: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),

                    // category drop down selection menu in flutte
                    Row(children: [
                      Icon(Icons.category, color: Colors.black54),
                      SizedBox(width: 30),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("Select Category"),
                              value: selected_category_id,
                              items: Categories().categories.map((category) {
                                return DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selected_category_id = value as int;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),

                    TextField(
                      textAlign: TextAlign.start,
                      obscureText: !_passvisible,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      decoration: kInputBoxDecoration.copyWith(
                          hintText: "Password",
                          icon: Icon(Icons.lock),
                          suffixIcon: PasswordShowButton(
                              onpressed: () {
                                setState(() {
                                  _passvisible = !_passvisible;
                                });
                              },
                              passvisible: _passvisible)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: showError,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Password should've at least 6 characters",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    CustomButton(
                      buttonColor: Colors.blue,
                      onPressed: () async {
                        if (password.length < 6) {
                          setState(() {
                            showError = true;
                          });
                        } else {
                          // SEND DATA TO SERVER FOR LOGIN
                          // IMPLEMENT THIS LATER
                          //
                          //
                          //
                          // FOR NOW JUST FORWARD TO HOMEPAGE
                          UserApiHandler api = UserApiHandler();
                          // loading stuts for apicall
                          setState(() {
                            is_loading = true;
                          });
                          try {
                            await api.register_labor(name, phone_number, email,
                                password, selected_category_id);
                            Navigator.pushNamedAndRemoveUntil(context, '/home',
                                (Route<dynamic> route) => false);
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        }
                      },
                      buttonText: "Sign up",
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    const DividerWithText(text: 'OR'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Joined us before? Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString(),
                    style: kHeadTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  )
                ],
              )),
            );
          } else {
            return Scaffold(
              body: CircularLoader(),
            );
          }
        });
  }
}
