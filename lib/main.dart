import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/create_account_screen.dart'; 
import 'screens/auth/login_screen.dart';
import 'screens/auth/password_screen.dart';
import 'screens/main_app/main_app_screen.dart';
import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favourites_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/create-account': (context) => const CreateAccountScreen(), 
          '/login': (context) => const LoginScreen(), 
          '/password': (context) => const PasswordScreen(), 
          '/main': (context) => const MainAppScreen(), 
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}