import 'package:flutter/material.dart';

class SignInPageModel {
  TextEditingController fullname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordAgain = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscureText = false;
}
