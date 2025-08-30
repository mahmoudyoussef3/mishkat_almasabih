import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.secondaryBackground,
      appBar: AppBar(
        foregroundColor: ColorsManager.secondaryBackground,
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsManager.primaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h,),
            Container(
              padding:  EdgeInsets.symmetric(horizontal:16.w,vertical: 24.h),
              decoration:  BoxDecoration(
                color: ColorsManager.primaryGreen,
                borderRadius: BorderRadius.circular(40)
        
                ),
              
              child: Column(
                children:  [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("assets/images/app_logo.png"), 
                  ),
                  SizedBox(height: 12),
                  Text(
                    "محمد يوسف",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "mahmooud@example.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- خيارات الملف الشخصي ---
            _buildProfileOption(
              icon: Icons.person,
              title: "تعديل البيانات",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.history,
              title: "سجل البحث",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.favorite,
              title: "المحفوظات",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.language,
              title: "تغيير اللغة",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.notifications,
              title: "الإشعارات",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: "تسجيل الخروج",
              onTap: () {},
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء العنصر
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red :ColorsManager.primaryGreen,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_back_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
