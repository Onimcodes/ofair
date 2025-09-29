import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/routing/router.dart';
import 'package:ofair/common/routing/router_names.dart';
import 'package:ofair/common/widgets/gaps.dart';
import 'package:ofair/common/widgets/page_scaffold.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/presentation/register_bloc/register_block.dart';
import 'package:ofair/presentation/register_bloc/register_event.dart';
import 'package:ofair/presentation/register_bloc/register_state.dart';
import 'package:ofair/screens/auth/widgets/user_pass_form.dart';
import 'package:ofair/screens/auth/widgets/welcome_text.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit<RegisterBloc>(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            // Handle success - navigate to next screen
            Fluttertoast.showToast(
              msg: "🎉 Registration successful!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.white,
              fontSize: 18.0,
            );
            AppRouter.go(context, RouterNames.loginPage);
            // Navigate to login or home page
          } else if (state.status == RegisterStatus.error) {
            // Handle error - show error message
            Fluttertoast.showToast(
              msg: "❌ ${state.errorMessage ?? 'Registration failed'}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 18.0,
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return CommonPageScaffold(
              title: 'Sign Up',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WelcomeText(),
                  GapWidgets.h48,
                  UserPassForm(
                    buttonLable: 'Sign Up',
                    loading: state.status == RegisterStatus.loading,
                    onFormSubmit: (String email, String password) async {
                      context.read<RegisterBloc>().add(
                        RegisterUserEvent(email: email, password: password),
                      );
                    },
                  ),

                  GapWidgets.h48,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ?"),
                      TextButton(
                        onPressed: () {
                          AppRouter.go(context, RouterNames.loginPage);
                        },
                        child: const Text('Log in '),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
