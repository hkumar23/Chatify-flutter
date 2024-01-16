import 'package:chatify2/providers/contacts_prov.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  String? email;
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
      await Provider.of<Contacts>(context,listen: false).addContact(email!,currUser!.uid,null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: const Text("Contact Added"),
          )
      );

    setState(() {
      isLoading=false;
    });
    }
    catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(err.toString()),
          )
      );
      setState(() {
        isLoading=false;
      });
      return;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Contact"),
        ),
      body: Stack(
        children:[                   
          // Container(            
          //   color: Theme.of(context).colorScheme.primaryContainer,
          //   height: MediaQuery.of(context).size.height*0.4,
          // ),
          Container(
              height: MediaQuery.of(context).size.height*0.4,
              decoration: BoxDecoration(                
                image: DecorationImage(
                  fit: BoxFit.cover,     
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface.withOpacity(0.5), BlendMode.multiply),
                  image: const NetworkImage(                                       
                    "https://img.freepik.com/free-vector/accept-request-concept-illustration_114360-2964.jpg?w=740&t=st=1704612213~exp=1704612813~hmac=b78007936d99347ab3afd3816ba32b3195547e4c193ecabd00cf6d44a9c2ac9e",
                    ),
                  ),
              ),
          ),  
           SingleChildScrollView(
             child: 
             Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [  
                        const SizedBox(height: 180,),       
                        Container(
                        margin: const EdgeInsets.all(15),
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                          minWidth: 300,
                          ),
                        child: Card(            
                          color: Theme.of(context).colorScheme.surface,
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
                                        icon: const Icon(Icons.cancel_rounded),
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
                                  const SizedBox(height: 20,),
                                  isLoading ?
                                  CircularProgressIndicator(color: Theme.of(context).colorScheme.onSecondaryContainer,) :
                                  FilledButton(                                    
                                    onPressed: ()=>_submit(context), 
                                    child: const Text("Add Contact"),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                       ),
                       const SizedBox(height: 10,),
                       OutlinedButton(
                        onPressed: () async {
                          const sharedText="Hey! I am using Chatify.\nJoin me to chat with your friends.\nDownload the app from:\nhttps://drive.google.com/file/d/1D9q9tY-2tL1kfZc9AcZtrgi8whPtQrhI/view?usp=drive_link";
                          await Share.share(sharedText,subject: "Hey! I am using Chatify.",);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Share "),
                            Icon(Icons.share),
                          ],)
                        ),
                       Text(
                            "Invite your friends to Chatify",
                            style: Theme.of(context).textTheme.titleMedium,
                            ),
                       ]
                     ),
           ),
        ]
      ),
    );
  }
}
