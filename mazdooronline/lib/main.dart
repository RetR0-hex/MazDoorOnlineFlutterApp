import 'package:flutter/material.dart';
import 'package:mazdooronline/route_observer/route_observer.dart';
import 'package:mazdooronline/screens/bill_screen.dart';
import 'package:provider/provider.dart';
import 'models/location.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/waiting.dart';
import 'package:mazdooronline/models/user.dart';
import 'constants.dart';
import 'screens/home_screen.dart';
import 'screens/hiring.dart';
import 'screens/order.dart';
import 'package:flutter_config/flutter_config.dart'; // for env file reading
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),
        ChangeNotifierProvider<LocationData>(
          create: (_) => LocationData(),
        ),
      ],
      child: MaterialApp(
        theme: kCustomTheme,
        navigatorObservers: [routeObserver],
        builder: EasyLoading.init(),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          '/welcome_screen': (context) => WelcomeScreen(),
          '/login': (context) => LoginScreen(),
          '/sign-up' : (context) => SignupScreen(),
          '/home' : (context) => HomeScreen(),
          '/home/search' : (context) => Hiring(),
          '/home/waiting' : (context) => WaitingScreen(),
          '/home/order' : (context) => OrderScreen(),
          '/home/bill' : (context) => BillPaymentScreen()
        }
      ),
    );
  }
}
