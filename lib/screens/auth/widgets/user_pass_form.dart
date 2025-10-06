import 'package:flutter/material.dart';
import 'package:ofair/common/widgets/buttons.dart';
import 'package:ofair/common/widgets/gaps.dart';
import 'package:ofair/common/widgets/text_field.dart';
import 'package:ofair/domain/logics/email_pass_validators.dart';

class UserPassForm extends StatefulWidget {
  const UserPassForm({
    super.key,
    this.loading = false,
    required this.buttonLabel,
    required this.onFormSubmit,
    this.initialEmail,
  });

  final String buttonLabel;
  final Function(String, String) onFormSubmit;
  final bool loading;
  final String? initialEmail;

  @override
  State<UserPassForm> createState() => _UserPassFormState();
}

class _UserPassFormState extends State<UserPassForm> with EmailPassValidators {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController userNameController;
  late final TextEditingController passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.initialEmail ?? "");
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onFormSubmit(
        userNameController.text.trim(),
        passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextFormField(
            fieldController: userNameController,
            fieldValidator: validateEmail,
            label: 'Email',
          ),
          GapWidgets.h8,
          TextFormField(
            controller: passwordController,
            obscureText: _obscurePassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility
                ) ,
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },)
            ),
            
            
          ),
          GapWidgets.h24,
          widget.loading
              ? FilledButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                  ),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                )
              : HighlightButton(
                  text: widget.buttonLabel,
                  onPressed: _handleSubmit,
                ),
        ],
      ),
    );
  }
}
