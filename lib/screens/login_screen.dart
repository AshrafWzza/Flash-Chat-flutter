import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../blocs/auth_bloc.dart';
import '../components/show_exception_alert_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';
  String? email;
  String? password;

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is LoginLoading) {
      } else if (state is LoginSuccess) {
        Navigator.pushNamed(context, ChatScreen.id);
        //BlocProvider.of<ChatCubit>(context).getMessages(); // * Trigger bloc or inside chat screen in didChangeDependencies
      } else if (state is LoginFailure) {
        showExceptionAlertDialog(context,
            title: 'something went wrong', exception: state.exception);
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: (state is LoginLoading) ? state.isLoading : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email.', labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true, //for **** password
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        // overWirte hinttext
                        hintText: 'Enter your Password.',
                        labelText: 'Password'),
                  ),
                  const SizedBox(height: 24.0),
                  RoundedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                            LoginEvent(email: email!, password: password!));
                      },
                      textButton: 'Log In'),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
/*
 // * use BlocConsumer instead of BlocListener: doesn't rebuild UI
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
        } else if (state is LoginSuccess) {
          Navigator.pushNamed(context, ChatScreen.id);
        } else if (state is LoginFailure) {
          showExceptionAlertDialog(context,
              title: 'something went wrong', exception: state.exception);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: BlocProvider.of<LoginCubit>(context).isLoading ?? false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email.', labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true, //for **** password
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      // overWirte hinttext
                        hintText: 'Enter your Password.',
                        labelText: 'Password'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        BlocProvider.of<LoginCubit>(context)
                            .loginUser(email: email!, password: password!);
                      },
                      textButton: 'Log In'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
*/

}
