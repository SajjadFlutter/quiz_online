// ignore_for_file: unused_field, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_online/common/widgets/large_btn.dart';

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

  // change image profile
  // select image
  File? _image;
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException {
      Navigator.of(context).pop();
    }
  }
  // crop image
  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
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
        // actions: [
        //   Row(
        //     children: [
        //       IconButton(
        //         onPressed: () {},
        //         icon: Icon(
        //           CupertinoIcons.moon_fill,
        //           color: secondaryHeaderColor,
        //           size: 20.0,
        //         ),
        //       ),
        //       const SizedBox(width: 5.0),
        //     ],
        //   ),
        // ],
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
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.gallery),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 25.0,
                                    color: secondaryHeaderColor,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'گالری',
                                    style: TextStyle(
                                      color: secondaryHeaderColor,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.camera),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    size: 25.0,
                                    color: secondaryHeaderColor,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'دوربین',
                                    style: TextStyle(
                                      color: secondaryHeaderColor,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(),
                      ],
                    ),
                  );
                },
              );
            },
            child: Stack(
              children: [
                Container(
                  width: 95.0,
                  height: 95.0,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: _image == null
                        ? SvgPicture.asset(
                            'assets/images/profile.svg',
                            fit: BoxFit.cover,
                            color: Colors.grey.shade400,
                          )
                        : Image.file(File(_image!.path), fit: BoxFit.cover),
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
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
                  SizedBox(height: height * 0.05),
                  //
                  LargeBtn(
                    primaryColor: primaryColor,
                    formKey: _formKey,
                    title: 'ویرایش',
                    onPressed: () {
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
}
