import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../styles/app_colors.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/password_bubbles.png',
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5, 
              fit: BoxFit.cover,
            ),
          ),
          
          Positioned(
            left: 20,
            right: 20,
            top: 150, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Заголовок
                const Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.w800, 
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 30),
                
                const Text(
                  'Type your password',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SvgPicture.asset(
                        'assets/images/eye-slash.svg',
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          AppColors.textLight,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 83),
                
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
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: const Text(
                      'Start',
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