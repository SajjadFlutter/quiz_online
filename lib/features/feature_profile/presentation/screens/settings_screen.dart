// ignore_for_file: unused_field, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quiz_online/common/bloc/profile_image_cubit/change_profile_cubit.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
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
  bool _isObscure = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences sharedPreferences = locator<SharedPreferences>();
    usernameController.text = sharedPreferences.getString('username')!;
    emailController.text = sharedPreferences.getString('email')!;
    passwordController.text = sharedPreferences.getString('password')!;

    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    // get divice size
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryHeaderColor = Theme.of(context).secondaryHeaderColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تنظیمات',
          style: textTheme.titleMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: secondaryHeaderColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              doUserLogout();
            },
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(110.0),
              child: Icon(
                Icons.logout_outlined,
                color: secondaryHeaderColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40.0),

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
                              onTap: () => _pickImage(ImageSource.gallery),
                              child: Container(
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: _imagePath == null ? 40.0 : 20.0),
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.camera),
                              child: Container(
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        fontSize: 12.0,
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
                                        color:
                                            Colors.redAccent.withOpacity(0.15),
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
                                              fontSize: 12.0,
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
                            ? Image.file(File(_image!.path), fit: BoxFit.cover)
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

          const SizedBox(height: 50.0),

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
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'مثلا : علیرضا محمدی',
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    controller: usernameController,
                    // The validator receives the text that the user has entered.
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'لطفا نام کاربری را وارد کنید.';
                    //   }
                    //   return null;
                    // },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, top: 30.0),
                    child: Text(
                      'ایمیل',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      hintText: 'مثلا : alireza@gmail.com',
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),

                    // The validator receives the text that the user has entered.
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'لطفا ایمیل خود را وارد کنید.';
                    //   } else if (!value.endsWith('@gmail.com')) {
                    //     return 'لطفا یک ایمیل با پسوند @gmail.com وارد کنید.';
                    //   }
                    //   return null;
                    // },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, top: 30.0),
                    child: Text(
                      'گذرواژه',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      hintText: 'مثلا : alireza1234',
                      hintStyle:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'لطفا گذرواژه خود را وارد کنید.';
                    //   } else if (value.length < 8) {
                    //     return 'حداقل 8 کاراکتر وارد کنید.';
                    //   } else if (value.length > 20) {
                    //     return 'حداکثر 20 کاراکتر وارد کنید.';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: height * 0.05),
                  //
                  LargeBtn(
                    primaryColor: primaryColor,
                    formKey: _formKey,
                    child: const Text('ذخیره'),
                    onPressed: () {
                      if (_image == null) {
                        BlocProvider.of<ChangeProfileCubit>(context)
                            .changeUserInfoEvent(
                                'assets/images/profile.svg');
                      } else {
                        saveUserInfo(_image!.path);
                      }
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // userProvider.callRegisterApi(nameController.text, emailController.text, passwordController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // user log out
  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    // final user = ParseUser(email, password, null);
    var response = await user.logout();
    print(user);
    print(response);

    if (response.success) {
      // Is show auth screens
      PrefsOperator prefsOperator = locator<PrefsOperator>();
      prefsOperator.changeAuthState(true);
      print('ok');
    } else {
      print('خطا');
    }
  }

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
  }

  // crop image
  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  String? _imagePath;
  Future<void> saveUserInfo(String imagePath) async {
    SharedPreferences sharedPreferences = locator<SharedPreferences>();
    sharedPreferences.setString('imagePath', imagePath);

    // final username = usernameController.text.trim();
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();
    
    // print(username);

    // PrefsOperator prefsOperator = locator<PrefsOperator>();
    // prefsOperator.setUserInfo(imagePath,username, email, password);

    // BlocProvider.of<ChangeProfileCubit>(context).changeUserInfoEvent(path);
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
