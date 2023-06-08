// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/change_username_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
import 'package:quiz_online/common/widgets/large_btn.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetProfileScreen extends StatefulWidget {
  static const String routeName = '/set_profile_screen';

  const SetProfileScreen({super.key});

  @override
  State<SetProfileScreen> createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  TextEditingController usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          'تنظیمات پروفایل',
          style: textTheme.titleMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 200.0),

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
                                            fontSize: 12.0,
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
                                      borderRadius: BorderRadius.circular(18.0),
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

              const SizedBox(height: 30.0),

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
                      const SizedBox(height: 15.0),
                      TextFormField(
                        style: textTheme.labelLarge,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18.0),
                          prefixIcon: Icon(Icons.person, color: primaryColor),
                          hintText: 'مثلا : علیرضا محمدی',
                          hintStyle: const TextStyle(
                              fontSize: 13.0, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
              child: const Text('بزن بریم!'),
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

                  saveUserInfo(usernameController.text.trim());

                  // Is show auth screens
                  PrefsOperator prefsOperator = locator<PrefsOperator>();
                  prefsOperator.changeSetProfileState(false);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomeScreen.routeName,
                    ModalRoute.withName('/home_screen'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
