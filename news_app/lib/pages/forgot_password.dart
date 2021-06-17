import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/dialog.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var emailCtrl = TextEditingController();
  String _email;



  void handleSubmit (){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      resetPassword(_email);
    }
  }



  Future<void> resetPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance; 

    try{
      await auth.sendPasswordResetEmail(email: email);
      openDialog(context, 'Reset Password', 'An email has been sent to $email. \n\nGo to that link & reset your password.');

    } catch(error){
      openSnacbar(scaffoldKey, error.code);
      
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        
        
        body: Form(
            key: formKey,
            child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.keyboard_backspace), 
                    onPressed: (){
                      Navigator.pop(context);
                      
                    }),
                ),
                Text('reset your password', style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w700
                )).tr(),
                Text('follow the simple steps', style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                )).tr(),
                SizedBox(
                  height: 50,
                ),
                
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    labelText: 'Email Address'
                    //suffixIcon: IconButton(icon: Icon(Icons.email), onPressed: (){}),
                    
                  
                    
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value){
                    if (value.length == 0) return "Email can't be empty";
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 80,),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor)
                    ),
                    child: Text('submit', style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColorLight
                    ),).tr(),
                    onPressed: (){
                      handleSubmit();
                  }),
                ),
                SizedBox(height: 50,),
                
               
                
              ],
            ),
          ),
        ),
      
    );
  }
}