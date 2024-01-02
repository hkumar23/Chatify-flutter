import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  static const routeName='/add-contact-screen';

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey=GlobalKey<FormState>();

  final _emailController=TextEditingController();
  final _emailFocusNode=FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool isLoading=false;
  var email;
  var currUser=FirebaseAuth.instance.currentUser;

  void _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading=true;
    });

    try{
      final contactSnap=await FirebaseFirestore.instance.collection("contacts");
      contactSnap.doc(currUser!.uid).set({email:true});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: const Text("Contact Added"),
          )
      );
    }
    catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(err.toString()),
          )
      );
      return;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          constraints: const BoxConstraints(
            maxWidth: 500,
            minWidth: 300,
            ),
          child: Card(            
            color: Theme.of(context).colorScheme.secondaryContainer,
            elevation: 5,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(              
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [      
                    Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter the email address of your friend",
                        style: Theme.of(context).textTheme.headlineSmall,)
                      ),
                    TextFormField(                      
                      key: const Key("email"),
                      controller: _emailController,
                      focusNode: _emailFocusNode,

                      validator: (value) {
                        if(value!.isEmpty || !value.contains('@')){
                          return "Please enter a valid Email Address";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text("Email Address"),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: (){
                            _emailController.clear();
                            _emailFocusNode.requestFocus();
                          },
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value){
                        email=value;
                      },
                    ),
                    SizedBox(height: 20,),
                    FilledButton(
                      onPressed: (){}, 
                      child: Text("Add Contact"),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}