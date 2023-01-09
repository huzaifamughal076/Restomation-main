import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restomation/MVVM/View%20Model/Login%20View%20Model/login_view_model.dart';
import 'package:restomation/Utils/app_routes.dart';
import 'package:restomation/Widgets/custom_app_bar.dart';
import 'package:restomation/Widgets/custom_button.dart';
import 'package:restomation/Widgets/custom_text.dart';
import 'package:restomation/Widgets/custom_text_field.dart';

import '../../Models/Login Model/login_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    email.text = 'naqeeb9a@gmail.com';
    password.text = 'naqeeb123';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = context.watch<LoginViewModel>();
    return Scaffold(
      appBar: BaseAppBar(title: "Login", appBar: AppBar(), widgets: const [], appBarHeight: 50),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: SizedBox(width: 500, child: loginView(context, loginViewModel))),
          ),
        ),
      ),
    );
  }

  Widget loginView(BuildContext context, LoginViewModel loginViewModel) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Image.network(
              "https://cdn.onlinewebfonts.com/svg/img_59062.png",
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: CustomText(text: "Email Address"),
          ),
          const SizedBox(
            height: 10,
          ),
          FormTextField(
            controller: email,
            suffixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field can't be empty";
              }
              if (!value.contains("@") || !value.contains(".")) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: CustomText(text: "Password"),
          ),
          const SizedBox(
            height: 10,
          ),
          FormTextField(
            controller: password,
            isPass: true,
            suffixIcon: const Icon(Icons.visibility_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field can't be empty";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CustomText(
                text: "Forgot password?",
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Align(
              alignment: Alignment.center,
              child: loginViewModel.loading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      buttonColor: Colors.amber,
                      text: "login",
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          await loginViewModel.loginUser(email.text, password.text).then((value) {
                            if (loginViewModel.modelError != null) {
                              Fluttertoast.showToast(msg: loginViewModel.modelError!.errorResponse.toString());
                              return;
                            }
                            pushScreen(loginViewModel.loggedInUser!);
                          });
                        }
                      })),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  pushScreen(LoginModel loginModel) {
    if (loginModel.role == "super_admin") {
      context.push("/home");
      return;
    }
    if (loginModel.role == "restaurant_admin") {
      context.push("/restaurant-details");
      return;
    }
    Fluttertoast.showToast(msg: "Unkown role please contact super admin");
  }

  showError() {
    KRoutes.pop(context);
    Fluttertoast.showToast(msg: "Invalid credientials");
  }
}
