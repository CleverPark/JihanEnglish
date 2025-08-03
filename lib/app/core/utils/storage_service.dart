import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/user_model.dart';
import '../values/app_constants.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // User data methods
  void saveUserData(UserModel user) {
    _box.write(AppConstants.userStorageKey, user.toJson());
  }

  UserModel? getUserData() {
    final data = _box.read(AppConstants.userStorageKey);
    return data != null ? UserModel.fromJson(data) : null;
  }

  void clearUserData() {
    _box.remove(AppConstants.userStorageKey);
  }

  // First run check
  bool isFirstRun() {
    return _box.read(AppConstants.firstRunKey) ?? true;
  }

  void setFirstRunComplete() {
    _box.write(AppConstants.firstRunKey, false);
  }

  // Generic methods
  void saveData(String key, dynamic value) {
    _box.write(key, value);
  }

  T? getData<T>(String key) {
    return _box.read<T>(key);
  }

  void removeData(String key) {
    _box.remove(key);
  }

  void clearAll() {
    _box.erase();
  }
}