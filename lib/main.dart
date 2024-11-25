import 'package:HomeQuest/pages/home_page.dart';
import 'package:HomeQuest/secrets/secret.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/create_property_page.dart';
import 'pages/saved_properties.dart';
import 'pages/account_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
      anonKey: AppSecrets.supabaseKey, url: AppSecrets.supabaseUrl);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/create': (context) => CreatePropertyPage(),
        '/saved': (context) => SavedPropertiesPage(),
        '/account': (context) => AccountPage(),
      },
    );
  }
}
