import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mazdooronline/components/appbar.dart';
import 'package:mazdooronline/constants.dart';
import 'package:mazdooronline/components/custom_button.dart';
import 'package:mazdooronline/components/divider.dart';
import 'package:mazdooronline/components/password_show.dart';
import '/API/USER_API_HANDLER.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool showError = false;
  String errorText = "";
  bool _passvisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Login', style: kLoginScreenTextStyle),
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
              height: 18,
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
                }, passvisible: _passvisible),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Visibility(
              visible: showError,
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  errorText,
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
                    errorText = "Password should've at least 6 characters";
                  });
                } else {
                  // SEND DATA TO SERVER FOR LOGIN
                  // IMPLEMENT THIS LATER
                  //
                  //
                  //
                  // FOR NOW JUST FORWARD TO HOMEPAGE
                  //
                  try {
                    UserApiHandler api = UserApiHandler();
                    await api.login_user(email, password);
                    Navigator.pushNamedAndRemoveUntil(context, '/home',
                            (Route<dynamic> route) => false);
                  }
                  catch(e){
                    EasyLoading.showInfo(e.toString());
                  }
                }
              },
              buttonText: "Log in",
            ),
            SizedBox(
              height: 18,
            ),
            const DividerWithText(text: 'OR'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign-up');
                },
                child: Text(
                  "New to us? Sign up",
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
