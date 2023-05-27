import 'package:quiz_online/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsOperator {
  late SharedPreferences sharedPreferences;

  PrefsOperator() {
    sharedPreferences = locator<SharedPreferences>();
  }

  // for Onboarding screen
  changeIntroState(bool value) {
    sharedPreferences.setBool('showIntro', value);
  }

  Future<bool> getShowState() async {
    return sharedPreferences.getBool('showIntro') ?? true;
  }

  // for user authentication
  changeAuthState(bool value) {
    sharedPreferences.setBool('showAuth', value);
  }

  Future<bool> getAuthState() async {
    return sharedPreferences.getBool('showAuth') ?? true;
  }

  // set user info
  setUserInfo(String imagePath,String username, String email, String password) {
    sharedPreferences.setString('imagePath', imagePath);
    sharedPreferences.setString('username', username);
    sharedPreferences.setString('email', email);
    sharedPreferences.setString('password', password);
  }
}
