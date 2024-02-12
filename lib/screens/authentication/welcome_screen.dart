import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/screens/authentication/login_screen.dart';
import 'package:chatify2/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.tertiaryContainer,
              ])),
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text(
                  AppLanguage.chatify,
                  style: GoogleFonts.pacifico(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLanguage.hello,
                      style: GoogleFonts.raleway(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Lets get started!",
                      style: GoogleFonts.raleway(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignupScreen.routeName);
                      },
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 92, vertical: 12)),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                        elevation: const MaterialStatePropertyAll(5),
                        shadowColor: MaterialStatePropertyAll(
                            Colors.black.withOpacity(0.5)),
                      ),
                      child: const Text(
                        AppLanguage.signUp,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(AppLanguage.or),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        maximumSize:
                            const MaterialStatePropertyAll(Size(500, 50)),
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 26, vertical: 12)),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.inverseSurface),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onInverseSurface),
                        elevation: const MaterialStatePropertyAll(5),
                        shadowColor: MaterialStatePropertyAll(
                            Colors.black.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            "https://freepngimg.com/download/google/66912-logo-now-google-plus-search-free-transparent-image-hd.png",
                            fit: BoxFit.fitHeight,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Signup with Google",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account ?",
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName);
                            },
                            child: const Text(AppLanguage.loginHere),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
