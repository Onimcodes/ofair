import 'package:flutter/material.dart';
import 'package:ofair/common/widgets/buttons.dart';
import 'package:ofair/common/widgets/gaps.dart';
import 'package:ofair/common/widgets/text_field.dart';
import 'package:ofair/domain/logics/email_pass_validators.dart';


class UserPassForm extends StatelessWidget with EmailPassValidators {
   UserPassForm({
    super.key,
    this.loading  = false,
    required this.buttonLable,
    required this.onFormSubmit
  });
   final String buttonLable;
   final Function(String, String) onFormSubmit;
   final TextEditingController userNameController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
    final bool loading;

   final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

     return Form(
        key: _formKey,

      child: Column(
     
        children: [
          AppTextFormField(
            fieldController: userNameController,
            fieldValidator:validateEmail ,
             label: 'Username'),

             GapWidgets.h8,
             
          AppTextFormField(
            fieldController: passwordController,
            obscureText: true,
            fieldValidator: validatePassword,
             label: 'Password'),
             GapWidgets.h24,
       
             loading
             ? const CircularProgressIndicator()
             :   HighlightButton(text: buttonLable, onPressed: () {
            debugPrint("I got here ${userNameController.text} and ${passwordController.text}");

             try {
                // Code that might throw an exception
              if(_formKey.currentState!.validate()) {
            debugPrint("I got here ${userNameController.text} and ${passwordController.text} too");

            onFormSubmit(userNameController.text, passwordController.text);

            }
                throw Exception('Something went wrong!');
                } catch (error, stackTrace) {
                  print('Caught an error: $error');
                  print('Stack Trace: $stackTrace');
                  // You can also log this information to a remote service
                }
        
          })
              
        ],
      ));
  }
}