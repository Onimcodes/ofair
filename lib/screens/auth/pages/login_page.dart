import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/routing/router.dart';
import 'package:ofair/common/routing/router_names.dart';
import 'package:ofair/common/widgets/gaps.dart';
import 'package:ofair/common/widgets/page_scaffold.dart';
import 'package:ofair/presentation/login_bloc/login_bloc.dart';
import 'package:ofair/presentation/login_bloc/login_event.dart';
import 'package:ofair/presentation/login_bloc/login_state.dart';
import 'package:ofair/screens/auth/widgets/user_pass_form.dart';
import 'package:ofair/screens/auth/widgets/welcome_text.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit<LoginBloc>(),
      child: BlocListener<LoginBloc,LoginState>(listener: (context, state) {

        if (state.status == LoginStatus.success) {
          Fluttertoast.showToast(
            msg: "🎉 Login successful!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          AppRouter.go(context, RouterNames.usersPage);
        } else if (state.status == LoginStatus.error) {
          Fluttertoast.showToast(
            msg: "❌ ${state.errorMessage ?? 'Login failed'}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 18.0,
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context,state) {
        return CommonPageScaffold(
      
      title: 'Login',
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const WelcomeText(),
        GapWidgets.h16,
        UserPassForm(
          buttonLable: 'login',
          loading: state.status == LoginStatus.loading,
         onFormSubmit: (
         String email,
         String password,
         ) async  {
          
                  context.read<LoginBloc>().add(LoginUserEvent(email: email, password: password));
            
         }),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [     
            const Text("Dont\'t have an account ?"),
            TextButton(onPressed: () {
              AppRouter.go(context, RouterNames.registerPage);
            },
            child: const Text('Sign up'))
          ],
         ),
        //  GapWidgets.h8,
        //  const Text('Or login with'), 
        //  SocialLogin(
        //   onAppleLogin:null,
        //   onGoogleLogin:  () {
        //     ref.read(loginStateProvider.notifier)
        //     .signInGoogle();
        //   },
        //  )
        

      ],
       ));
      }),),
    );
  }
}