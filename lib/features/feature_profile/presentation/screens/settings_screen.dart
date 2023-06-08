// ignore_for_file: unused_field, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/change_username_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/common/widgets/custom_appbar.dart';
import 'package:quiz_online/common/widgets/large_btn.dart';
import 'package:quiz_online/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // bool _isObscure = true;

  @override
  void dispose() {
    usernameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();

    super.dispose();
  }

  SharedPreferences sharedPreferences = locator<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    usernameController.text = sharedPreferences.getString('username')!;

    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryHeaderColor = Theme.of(context).secondaryHeaderColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // appbar
                CustomAppbar(
                  width: width,
                  secondaryHeaderColor: secondaryHeaderColor,
                  textTheme: textTheme,
                  title: 'تنظیمات',
                  iconData: Icons.arrow_back_rounded,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 35.0),

                // image profile
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: height * 0.25,
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 20.0, bottom: 20.0, right: 20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 25.0,
                                    height: 5.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  const SizedBox(height: 25.0),
                                  Text(
                                    'تغییر تصویر پروفایل',
                                    style: textTheme.labelLarge,
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _pickImage(ImageSource.gallery),
                                    child: Container(
                                      width: 90.0,
                                      height: 90.0,
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 30.0,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(height: 6.0),
                                          Text(
                                            'از گالری',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: _imagePath == null ? 40.0 : 20.0),
                                  GestureDetector(
                                    onTap: () => _pickImage(ImageSource.camera),
                                    child: Container(
                                      width: 90.0,
                                      height: 90.0,
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.rotationY(110.0),
                                            child: Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 30.0,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 6.0),
                                          Text(
                                            'از دوربین',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _imagePath == null ? false : true,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 20.0),
                                        GestureDetector(
                                          onTap: () => deleteImage(),
                                          child: Container(
                                            width: 90.0,
                                            height: 90.0,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.delete,
                                                  size: 26.0,
                                                  color: Colors.redAccent,
                                                ),
                                                SizedBox(height: 10.0),
                                                Text(
                                                  'حذف',
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 11.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: _imagePath != null
                              ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                              : _image != null
                                  ? Image.file(File(_image!.path),
                                      fit: BoxFit.cover)
                                  : SvgPicture.asset(
                                      'assets/images/profile.svg',
                                      fit: BoxFit.cover,
                                      color: Colors.grey.shade400,
                                    ),
                        ),
                      ),
                      Positioned(
                        right: 3.0,
                        bottom: 0.0,
                        child: Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Colors.white, width: 3.0),
                          ),
                          child: const Icon(
                            Icons.mode_edit_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(
                            'نام کاربری',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          style: textTheme.labelLarge,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: primaryColor),
                            hintText: 'مثلا : علیرضا محمدی',
                            hintStyle: const TextStyle(
                                fontSize: 13.0, color: Colors.grey),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2.0),
                            ),
                          ),
                          controller: usernameController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا یک نام کاربری برای خود انتخاب کنید.';
                            }
                            return null;
                          },
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 5.0, top: 30.0),
                        //   child: Text(
                        //     'ایمیل',
                        //     style: TextStyle(
                        //       fontSize: 12.0,
                        //       color: secondaryHeaderColor,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        // TextFormField(
                        //   controller: emailController,
                        //   decoration: const InputDecoration(
                        //     prefixIcon: Icon(Icons.email_rounded),
                        //     hintText: 'مثلا : alireza@gmail.com',
                        //     hintStyle:
                        //         TextStyle(fontSize: 14.0, color: Colors.grey),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: Colors.blue, width: 2.0),
                        //     ),
                        //   ),
                        //
                        //   // The validator receives the text that the user has entered.
                        //   // validator: (value) {
                        //   //   if (value == null || value.isEmpty) {
                        //   //     return 'لطفا ایمیل خود را وارد کنید.';
                        //   //   } else if (!value.endsWith('@gmail.com')) {
                        //   //     return 'لطفا یک ایمیل با پسوند @gmail.com وارد کنید.';
                        //   //   }
                        //   //   return null;
                        //   // },
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 5.0, top: 30.0),
                        //   child: Text(
                        //     'گذرواژه',
                        //     style: TextStyle(
                        //       fontSize: 12.0,
                        //       color: secondaryHeaderColor,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        // TextFormField(
                        //   controller: passwordController,
                        //   obscureText: _isObscure,
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(Icons.lock_open),
                        //     suffixIcon: IconButton(
                        //       icon: Icon(
                        //         _isObscure
                        //             ? Icons.visibility
                        //             : Icons.visibility_off,
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           _isObscure = !_isObscure;
                        //         });
                        //       },
                        //     ),
                        //     hintText: 'مثلا : alireza1234',
                        //     hintStyle: const TextStyle(
                        //         fontSize: 14.0, color: Colors.grey),
                        //     focusedBorder: const UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: Colors.blue, width: 2.0),
                        //     ),
                        //   ),
                        //   // The validator receives the text that the user has entered.
                        //   // validator: (value) {
                        //   //   if (value == null || value.isEmpty) {
                        //   //     return 'لطفا گذرواژه خود را وارد کنید.';
                        //   //   } else if (value.length < 8) {
                        //   //     return 'حداقل 8 کاراکتر وارد کنید.';
                        //   //   } else if (value.length > 20) {
                        //   //     return 'حداکثر 20 کاراکتر وارد کنید.';
                        //   //   }
                        //   //   return null;
                        //   // },
                        // ),
                        // SizedBox(height: height * 0.05),
                        //
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // save btn
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, bottom: 20.0, right: 15.0),
              child: LargeBtn(
                primaryColor: primaryColor,
                formKey: _formKey,
                child: const Text('ذخیره'),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // userProvider.callRegisterApi(nameController.text, emailController.text, passwordController.text);
                    if (_image == null) {
                      BlocProvider.of<ChangeProfileImageCubit>(context)
                          .changeUserInfoEvent('assets/images/profile.svg');
                    } else {
                      saveImage(_image!.path);
                    }

                    saveUserInfo(
                      usernameController.text.trim(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // user log out
  // void doUserLogout() async {
  //   final user = await ParseUser.currentUser() as ParseUser;
  //   // final user = ParseUser(email, password, null);
  //   var response = await user.logout();
  //   print(user);
  //   print(response);
  //   if (response.success) {
  //     // Is show auth screens
  //     PrefsOperator prefsOperator = locator<PrefsOperator>();
  //     prefsOperator.changeAuthState(true);
  //     print('ok');
  //   } else {
  //     print('خطا');
  //   }
  // }

  // change image profile
  // select image
  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      File? img = File(image!.path);
      img = await _cropImage(imageFile: img);

      setState(() {
        _image = img;
        Navigator.pop(context);
      });
    } on PlatformException {
      Navigator.pop(context);
    }

    setState(() {});
  }

  // crop image
  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) {
      return null;
    } else {
      setState(() {});
      return File(croppedImage.path);
    }
  }

  String? _imagePath;
  Future<void> saveImage(String imagePath) async {
    SharedPreferences sharedPreferences = locator<SharedPreferences>();
    sharedPreferences.setString('imagePath', imagePath);

    BlocProvider.of<ChangeProfileImageCubit>(context)
        .changeUserInfoEvent(imagePath);
  }

  Future<void> saveUserInfo(String username) async {
    SharedPreferences sharedPreferences = locator<SharedPreferences>();
    sharedPreferences.setString('username', username);

    BlocProvider.of<ChangeUsernameCubit>(context).changeUsernameEvent(username);
  }

  Future<void> loadImage() async {
    SharedPreferences sharedPreferences = locator<SharedPreferences>();

    setState(() {
      _imagePath = sharedPreferences.getString('imagePath');
    });
  }

  Future<void> deleteImage() async {
    SharedPreferences sharedPreferences = locator<SharedPreferences>();
    sharedPreferences.remove('imagePath');

    setState(() {
      _imagePath = null;
      _image = null;
    });

    Navigator.pop(context);
  }
}
