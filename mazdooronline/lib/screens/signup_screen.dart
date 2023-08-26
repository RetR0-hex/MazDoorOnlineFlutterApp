import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mazdooronline/API/USER_API_HANDLER.dart';
import 'package:mazdooronline/components/appbar.dart';
import 'package:mazdooronline/constants.dart';
import 'package:mazdooronline/components/divider.dart';
import 'package:mazdooronline/components/custom_button.dart';
import 'package:mazdooronline/components/password_show.dart';


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

  void changepasswordstate(){
    setState(() {
      _passvisible = !_passvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Sign up', style: kLoginScreenTextStyle),
            SizedBox(
              height: 30,
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
                suffixIcon: PasswordShowButton(onpressed: (){
                  setState(() {
                    _passvisible = !_passvisible;
                  });
                }, passvisible: _passvisible)
              ),
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
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
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
                  try {
                    await api.register_user(
                        name, phone_number, email, password);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (Route<dynamic> route) => false);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
