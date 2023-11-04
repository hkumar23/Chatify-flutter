import 'package:chatify2/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:chatify2/screens/chat_screen.dart';
import 'package:chatify2/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness themeBrightness=Brightness.light;

  void toggleTheme(){
    setState(() {      
      if(themeBrightness==Brightness.dark){
        themeBrightness=Brightness.light;
      }
      else{
        themeBrightness=Brightness.dark;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chatify2',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //   primary: Colors.blue,
        //   seedColor: Colors.blue,
        //   surface: Colors.blue.shade50,
        //   secondary: Colors.blueGrey,
        //   ),
        colorSchemeSeed: Colors.blue,
        // primarySwatch: Colors.blue,
        brightness: themeBrightness,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.blue,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
        //   )
        // ),
        // textButtonTheme: TextButtonThemeData(
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.blue,
        //   )
        // ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (ctx,userSnapshot){
          if(userSnapshot.hasData){
            return HomeScreen(themeBrightness,toggleTheme);
          }
          return AuthScreen(themeBrightness,toggleTheme);
        },
        ),
      routes: {
        HomeScreen.routeName :(context) => HomeScreen(themeBrightness,toggleTheme),
        ChatScreen.routeName :(context) => ChatScreen(themeBrightness, toggleTheme),
      },
    );
  }
}
