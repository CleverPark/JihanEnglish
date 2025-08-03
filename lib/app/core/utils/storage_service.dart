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
    print('DEBUG Storage: Saving user data');
    print('DEBUG Storage: completionCounts=${user.completionCounts}');
    _box.write(AppConstants.userStorageKey, user.toJson());
    print('DEBUG Storage: User data saved to storage');
  }

  UserModel? getUserData() {
    final data = _box.read(AppConstants.userStorageKey);
    final user = data != null ? UserModel.fromJson(data) : null;
    if (user != null) {
      print('DEBUG Storage: Retrieved user data');
      print('DEBUG Storage: completionCounts=${user.completionCounts}');
    } else {
      print('DEBUG Storage: No user data found');
    }
    return user;
  }

  void clearUserData() {
    _box.remove(AppConstants.userStorageKey);
  }

  // Book data methods
  void saveBookData(List<Map<String, dynamic>> bookData) {
    _box.write(AppConstants.bookStorageKey, bookData);
  }

  List<Map<String, dynamic>>? getBookData() {
    final data = _box.read(AppConstants.bookStorageKey);
    if (data != null && data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return null;
  }

  void clearBookData() {
    _box.remove(AppConstants.bookStorageKey);
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