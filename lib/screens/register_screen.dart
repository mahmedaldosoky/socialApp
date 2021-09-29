import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/componentes/default_text_field.dart';
import 'package:social/providers/auth_provider.dart';


class RegisterScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Register now to communicate with friends',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  DefaultTextField(
                    hintText: "User Name",
                    controller: usernameController,
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  DefaultTextField(
                    hintText: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Provider.of<AuthProvider>(context).registerLoading
                      ? Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          onPressed: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .registerEmail(
                              context,
                              emailController.text,
                              passwordController.text,
                              usernameController.text,
                              phoneController.text,
                            );
                          },
                          child: Text(
                            "Register",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
