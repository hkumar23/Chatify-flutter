import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/providers/contacts_prov.dart';
import 'package:chatify2/screens/addcontact_screen.dart';
import 'package:chatify2/screens/authentication/welcome_screen.dart';
import 'package:chatify2/screens/create_post_screen.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/screens/messages_screen.dart';
import 'package:chatify2/screens/authentication/login_screen.dart';
import 'package:chatify2/screens/settings_screen.dart';
import 'package:chatify2/screens/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:chatify2/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness themeBrightness = Brightness.light;

  void toggleTheme() {
    setState(() {
      if (themeBrightness == Brightness.dark) {
        themeBrightness = Brightness.light;
      } else {
        themeBrightness = Brightness.dark;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Contacts()),
      ],
      child: MaterialApp(
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
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return const HomeScreen();
            }
            return const AuthScreen();
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          AddContactScreen.routeName: (context) => const AddContactScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          SettingsScreen.routeName: (context) =>
              SettingsScreen(toggleTheme, themeBrightness),
          AuthScreen.routeName: (context) => const AuthScreen(),
          MessagesScreen.routeName: (context) => const MessagesScreen(),
          CreatePostScreen.routeName: (context) => const CreatePostScreen(),
        },
      ),
    );
  }
}
