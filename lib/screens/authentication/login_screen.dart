import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/authentication/signup_screen.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/screens/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // print("_trySubmit Called");
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // print("authenticated successfully");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (err) {
      debugPrint("Error Occured: $err");
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Rebuilded");
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const Key(AppLanguage.emailAddress),
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          // suffixIcon: IconButton(
                          //   onPressed: (){
                          //     _emailController.clear();
                          //     },
                          //   icon: const Icon(Icons.cancel),
                          // ),
                          label: Text(AppLanguage.emailAddress),
                        ),
                        // onSaved: (value){
                        //   _userEmail=value;
                        // },
                      ),
                      TextFormField(
                        key: const Key(AppLanguage.password),
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Password must be atleast 7 characters long.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text(AppLanguage.password)),
                        // onSaved: (value){
                        //   _userPassword=value;
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                              ),
                              onPressed: _trySubmit,
                              child: Text(
                                AppLanguage.login,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ),
                      if (!isLoading)
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignupScreen.routeName);
                          },
                          child: const Text("Create new Account"),
                        ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
