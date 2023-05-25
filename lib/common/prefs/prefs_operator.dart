import 'package:quiz_online/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsOperator {
  late SharedPreferences sharedPreferences;

  PrefsOperator() {
    sharedPreferences = locator<SharedPreferences>();
  }

  // for Onboarding screen
  changeIntroState() {
    sharedPreferences.setBool('showIntro', false);
  }

  Future<bool> getShowState() async {
    return sharedPreferences.getBool('showIntro') ?? true;
  }
}
