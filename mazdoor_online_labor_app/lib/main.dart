import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/bill_screen.dart';
import 'screens/home_screen_labour.dart';
import 'models/user.dart';
import 'models/order.dart';
import '/screens/order.dart';
import '/models/location.dart';
import 'constants.dart';
import 'package:flutter_config/flutter_config.dart'; // for env file reading
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'route_observer/route_observer.dart';

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
        ChangeNotifierProvider<ActiveOrdersList>(
          create: (_) => ActiveOrdersList(),
        ),
        ChangeNotifierProvider<LocationData>(
          create: (_) => LocationData(),
        ),
      ],
      child: MaterialApp(
          theme: kCustomTheme,
          builder: EasyLoading.init(),
          navigatorObservers: [routeObserver],
          initialRoute: '/',
          routes: {
            '/': (context) => WelcomeScreen(),
            '/welcome_screen': (context) => WelcomeScreen(),
            '/login': (context) => LoginScreen(),
            '/sign-up' : (context) => SignupScreen(),
            '/home' : (context) => LaborHome(),
            '/home/order' : (context) => OrderScreen(),
            '/home/bill' : (context) => BillPaymentScreen(),
          }
      ),
    );
  }
}