import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/componentes/default_text_field.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:social/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOGIN',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'login now to communicate with friends',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  DefaultTextField(
                    hintText: "Email Address",
                    controller: emailController,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    hintText: "Password",
                    controller: passwordController,
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Provider.of<AuthProvider>(context).loginLoading
                      ? Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          onPressed: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .loginEmail(emailController.text,
                                    passwordController.text,context);


                          },
                          child: Text(
                            "Login",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                          minWidth: double.infinity,
                          color: Theme.of(context).primaryColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 13),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen()));
                        },
                        child: Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
