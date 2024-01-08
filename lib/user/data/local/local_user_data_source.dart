import 'package:global_chat/user/data/model/constants/user_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserDataSource {
  final SharedPreferences sharedPreferences;
  const LocalUserDataSource({required this.sharedPreferences});
  
  String? getUserId() => sharedPreferences.getString(KEY_USER_ID);
}