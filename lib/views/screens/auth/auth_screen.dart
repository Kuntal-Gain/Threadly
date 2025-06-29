import 'package:clozet/views/screens/auth/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../utils/constants/color.dart';
import '../../utils/constants/textstyle.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final userController = Get.find<UserController>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLogin = false;

  void login() {
    userController.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void register() {
    userController.registerUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Clozet",
                style: TextStyleConst().headingStyle(
                  color: AppColor.white,
                  size: 50,
                ),
              ),
            ),
            Text(
              isLogin ? "Login" : "Signup",
              style: TextStyleConst().headingStyle(
                color: AppColor.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              isLogin ? "Login to your account" : "Create your account",
              style: TextStyleConst().headingStyle(
                color: AppColor.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isLogin
                  ? "Login to your account"
                  : "Create your account to access all features",
              style: TextStyleConst().headingStyle(
                color: AppColor.white,
                size: 16,
              ),
            ),
            const SizedBox(height: 30),
            if (!isLogin)
              _buildTextField(
                controller: nameController,
                icon: Icons.person,
                label: 'Full Name',
              ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              icon: Icons.email,
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: passwordController,
              icon: Icons.lock,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            Obx(() {
              return userController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        isLogin ? login() : register();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            isLogin ? "Login" : "Sign Up",
                            style: TextStyleConst().headingStyle(
                              color: AppColor.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'OR',
                  style: TextStyleConst().headingStyle(
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                authProvider(
                    "https://cdn-icons-png.flaticon.com/512/104/104093.png"),
                authProvider(
                    "https://cdn-icons-png.flaticon.com/512/20/20837.png"),
                authProvider(
                    "https://cdn-icons-png.flaticon.com/512/0/747.png"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
