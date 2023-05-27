// ignore_for_file: unused_field, prefer_final_fields, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
import 'package:quiz_online/common/widgets/large_btn.dart';
import 'package:quiz_online/common/widgets/main_wrapper.dart';
import 'package:quiz_online/features/feature_auth/presentation/screens/login_screen.dart';
import 'package:quiz_online/locator.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup_screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            SvgPicture.asset(
              'assets/images/sign.svg',
              width: width * 0.6,
              height: width * 0.6,
            ),
            const SizedBox(height: 30.0),
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        prefixIcon: Icon(Icons.person),
                        labelText: 'نام کاربری',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      controller: usernameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا نام کاربری را وارد کنید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        prefixIcon: Icon(Icons.email_rounded),
                        labelText: 'ایمیل',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا ایمیل خود را وارد کنید.';
                        } else if (!value.endsWith('@gmail.com')) {
                          return 'لطفا یک ایمیل با پسوند @gmail.com وارد کنید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18.0),
                        prefixIcon: const Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        labelText: 'گذرواژه',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفا گذرواژه خود را وارد کنید.';
                        } else if (value.length < 8) {
                          return 'حداقل 8 کاراکتر وارد کنید.';
                        } else if (value.length > 20) {
                          return 'حداکثر 20 کاراکتر وارد کنید.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.04),
                    //
                    LargeBtn(
                      primaryColor: primaryColor,
                      formKey: _formKey,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('ثبت نام'),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // userProvider.callRegisterApi(nameController.text, emailController.text, passwordController.text);
                          setState(() => isLoading = true);

                          doUserRegisteration(
                              emailController, passwordController);
                        }
                      },
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'قبلا در آزمون آنلاین عضو شده اید؟',
                          style: textTheme.labelMedium,
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                          },
                          child: const Text('ورود'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // user registeration
  Future<void> doUserRegisteration(emailController, passwordController) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    PrefsOperator prefsOperator = locator<PrefsOperator>();
    prefsOperator.setUserInfo('assets/images/profile.svg', username, email, password);

    final user = ParseUser.createUser(email, password, email);

    var response = await user.signUp();

    if (response.success) {
      final snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const ListTile(
            leading: Icon(Icons.done_rounded, color: Colors.white),
            title: Text(
              'ثبت نام شما با موفقیت انجام شد.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Is show auth screens
      PrefsOperator prefsOperator = locator<PrefsOperator>();
      prefsOperator.changeAuthState(false);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainWrapper.routeName,
          ModalRoute.withName('/main_wrapper'),
        );
      });
    } else {
      setState(() => isLoading = false);

      final snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        content: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const ListTile(
            leading: Icon(Icons.close_rounded, color: Colors.white),
            title: Text(
              'ثبت نام شما با مشکل مواجه شد ، لطفا دوباره امتحان کنید.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
