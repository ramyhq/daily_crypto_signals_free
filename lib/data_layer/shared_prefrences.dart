/* app keys
  userUid
  loginStatus
  isTokenSaved
  notificationToken
*/

import 'package:shared_preferences/shared_preferences.dart';

class CachingData {
 static late SharedPreferences _pref;

 static Future<void> init() async {
  _pref = await SharedPreferences.getInstance();
}

static Future saveString(String key, String data) async {
  await _pref.setString(key, data);
}
static Future saveListString(String key, List<String> data) async {
  await _pref.setStringList(key, data);
}
static Future saveInt(String key, int data) async {
  await _pref.setInt(key, data);
}
static Future saveBool(String key, bool data) async {
  await _pref.setBool(key, data);
}

 static dynamic getData(String key) async {
   return _pref.get(key);
 }


}