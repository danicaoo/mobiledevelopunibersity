import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../styles/app_colors.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
              'assets/images/create_account_bubbles.png',
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5, 
              fit: BoxFit.cover,
            ),
          ),
          
          Positioned(
            left: 30,
            top: 100, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create\nAccount',
                  style: TextStyle(
                    fontSize: 50, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 54 / 50, 
                  ),
                ),
              ],
            ),
          ),
          
          // Форма ввода
          Positioned(
            left: 20,
            right: 20,
            bottom: 95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 8),
                
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
                        'assets/icons/eye-slash.svg',
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
                const SizedBox(height: 8),
                
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Your number',
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/flag.png',
                            width: 24,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: AppColors.textLight,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 52),
                
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
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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