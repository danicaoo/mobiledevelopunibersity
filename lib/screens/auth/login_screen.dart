import 'package:flutter/material.dart';
import '../../screens/auth/password_screen.dart';
import '../../styles/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/login_bubbles.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          
          Positioned(
            left: 20,
            right: 20,
            bottom: 84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.w800, 
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                
                Row(
                  children: [
                    const Text(
                      'Good to see you back!',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.favorite,
                      color: AppColors.textLight,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none, 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    hintStyle: const TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 37),
                
                SizedBox(
                  width: double.infinity,
                  height: 61,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), 
                      ),
                      elevation: 0, 
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}