import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late TextEditingController _usernameController;
  File? _selectedImageFile;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.userData["username"] ?? "",
    );

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      appBar: AppBar(
        backgroundColor: ColorsManager.primaryPurple,
        foregroundColor: ColorsManager.white,
        elevation: 0,
        title: Text(
          "تعديل الملف الشخصي",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'YaModernPro',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child:
                _isLoading
                    ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorsManager.white,
                        ),
                      ),
                    )
                    : Text(
                      "حفظ",
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'YaModernPro',
                      ),
                    ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with gradient
                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.primaryPurple,
                        ColorsManager.secondaryPurple,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            'assets/images/islamic_pattern.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile content
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Avatar Section
                      _buildAvatarSection(),
                      SizedBox(height: 32.h),

                      // Username Section
                      _buildUsernameSection(),
                      SizedBox(height: 32.h),

                      // Info Card
                      _buildInfoCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        // Avatar with animation
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.primaryGold,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primaryGold.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: ColorsManager.secondaryBackground,
                      backgroundImage:
                          _selectedImageFile != null
                              ? FileImage(_selectedImageFile!)
                              : (widget.userData["avatar_url"] != null
                                  ? NetworkImage(widget.userData["avatar_url"])
                                  : null),
                      child:
                          (_selectedImageFile == null &&
                                  widget.userData["avatar_url"] == null)
                              ? Icon(
                                Icons.person,
                                size: 60.r,
                                color: ColorsManager.primaryPurple,
                              )
                              : null,
                    ),
                  ),
                  // Edit button with pulse animation
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1500),
                      tween: Tween(begin: 0.8, end: 1.0),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryPurple,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorsManager.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorsManager.primaryPurple
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: _selectAvatar,
                              icon: Icon(
                                Icons.camera_alt,
                                color: ColorsManager.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
        Text(
          "الصورة الشخصية",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.primaryText,
            fontFamily: 'YaModernPro',
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "انقر على الكاميرا لتغيير الصورة",
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorsManager.secondaryText,
            fontFamily: 'Amiri',
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "اسم المستخدم",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryText,
                fontFamily: 'YaModernPro',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: ColorsManager.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorsManager.mediumGray, width: 1),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _usernameController,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsManager.primaryText,
              fontFamily: 'YaModernPro',
            ),
            decoration: InputDecoration(
              hintText: "أدخل اسم المستخدم",
              hintStyle: TextStyle(
                color: ColorsManager.secondaryText,
                fontFamily: 'Amiri',
              ),
              prefixIcon: Icon(
                Icons.person,
                color: ColorsManager.primaryPurple,
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.lightPurple.withOpacity(0.1),
            ColorsManager.secondaryPurple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorsManager.lightPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorsManager.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  FontAwesomeIcons.infoCircle,
                  color: ColorsManager.primaryPurple,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "معلومات الحساب",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.primaryText,
                        fontFamily: 'YaModernPro',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "البريد الإلكتروني: ${widget.userData["email"] ?? "غير محدد"}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorsManager.secondaryText,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: ColorsManager.mediumGray, height: 1),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.calendar,
                color: ColorsManager.primaryPurple,
                size: 16.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                "تاريخ الإنشاء: ${_formatDate(widget.userData["created_at"])}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.secondaryText,
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.trophy,
                color: ColorsManager.primaryGold,
                size: 16.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                "الإنجازات الأسبوعية: ${widget.userData["weekly_achievement_count"] ?? 0}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.secondaryText,
                  fontFamily: 'Amiri',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: ColorsManager.cardBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorsManager.mediumGray,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "اختر صورة",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryText,
                    fontFamily: 'YaModernPro',
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatarOption(
                      icon: FontAwesomeIcons.camera,
                      title: "التقاط صورة",
                      subtitle: "استخدم الكاميرا",
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    _buildAvatarOption(
                      icon: FontAwesomeIcons.image,
                      title: "من المعرض",
                      subtitle: "اختر من الصور",
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onTap();
            },
            child: Container(
              width: 140.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ColorsManager.primaryPurple.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryPurple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryPurple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: ColorsManager.primaryPurple,
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorsManager.primaryText,
                      fontFamily: 'YaModernPro',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorsManager.secondaryText,
                      fontFamily: 'Amiri',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: ColorsManager.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "تم اختيار الصورة بنجاح",
                    style: TextStyle(
                      fontFamily: 'YaModernPro',
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              backgroundColor: ColorsManager.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: ColorsManager.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  "حدث خطأ أثناء اختيار الصورة",
                  style: TextStyle(fontFamily: 'YaModernPro', fontSize: 14.sp),
                ),
              ],
            ),
            backgroundColor: ColorsManager.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    }
  }

  void _saveChanges() async {
    if (_usernameController.text.trim().isEmpty) {
      _showErrorDialog("يرجى إدخال اسم المستخدم");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: ColorsManager.white, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                "تم حفظ التغييرات بنجاح",
                style: TextStyle(fontFamily: 'YaModernPro', fontSize: 14.sp),
              ),
            ],
          ),
          backgroundColor: ColorsManager.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              children: [
                Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: ColorsManager.error,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  "خطأ",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryText,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ],
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsManager.secondaryText,
                fontFamily: 'Amiri',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "حسناً",
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: 16.sp,
                    fontFamily: 'YaModernPro',
                  ),
                ),
              ),
            ],
          ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "غير محدد";
    try {
      final date = DateTime.parse(dateString);
      return "${date.year}/${date.month}/${date.day}";
    } catch (e) {
      return "غير محدد";
    }
  }
}
