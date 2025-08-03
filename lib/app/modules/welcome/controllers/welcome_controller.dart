import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class WelcomeController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final RxBool isNameValid = false.obs;
  final RxBool isLoading = false.obs;

  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_validateName);
  }

  @override
  void onReady() {
    super.onReady();
    _checkExistingUser();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void _validateName() {
    isNameValid.value = nameController.text.trim().isNotEmpty;
  }

  void _checkExistingUser() {
    final existingUser = _storageService.getUserData();
    if (existingUser != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> startGame() async {
    if (!isNameValid.value) return;

    isLoading.value = true;

    try {
      // Create new user
      final newUser = UserModel(
        userName: nameController.text.trim(),
        level: 1,
        currentExp: 0,
        requiredExp: 100,
        characterType: 'warrior',
        completedBooks: {},
        completionCounts: {},
        lastPlayed: DateTime.now(),
      );

      // Save user data
      _storageService.saveUserData(newUser);
      _storageService.setFirstRunComplete();

      // Navigate to home
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        '오류',
        '시작하는 중 문제가 발생했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}