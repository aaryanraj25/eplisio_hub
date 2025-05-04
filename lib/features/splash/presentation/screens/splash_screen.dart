import 'package:eplisio_hub/core/routes/app_routes.dart';
import 'package:eplisio_hub/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final authRepo = Get.find<AuthRepository>();

    // Use the isLoggedIn method instead of directly checking currentUser
    if (authRepo.isLoggedIn()) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      // Check if token exists without a user
      if (authRepo.token.isNotEmpty) {
        // Token exists but no user - this might be your issue
        print(
            "Token exists but no user object. Redirecting to dashboard anyway.");
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method remains unchanged
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace with your logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo/logo.png', // Replace with your actual path
                  height: 60,
                  width: 60,
                   // Optional: if your logo is monochrome and you want to tint it
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Eplisio Hub',
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
