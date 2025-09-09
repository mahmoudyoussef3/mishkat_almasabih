import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/theme_manager.dart';

/// Example widget demonstrating dark mode implementation
/// Shows how to use theme-aware colors and components
class DarkModeExample extends StatelessWidget {
  const DarkModeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Mode Example'),
        actions: [
          IconButton(
            icon: BlocBuilder<ThemeManager, ThemeMode>(
              builder: (context, themeMode) {
                return Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                );
              },
            ),
            onPressed: () {
              context.read<ThemeManager>().toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Status Card
            _buildThemeStatusCard(context),
            SizedBox(height: 20.h),

            // Color Palette Card
            _buildColorPaletteCard(context),
            SizedBox(height: 20.h),

            // Component Examples
            _buildComponentExamples(context),
            SizedBox(height: 20.h),

            // Islamic Content Example
            _buildIslamicContentExample(context),
            SizedBox(height: 20.h),

            // Theme Controls
            _buildThemeControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeStatusCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            BlocBuilder<ThemeManager, ThemeMode>(
              builder: (context, themeMode) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text('Current Mode: '),
                        Text(
                          themeMode.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text('Status: '),
                        Text(
                          context.read<ThemeManager>().getThemeStatusText(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPaletteCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Color Palette',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildColorSwatch(
                  'Primary Purple',
                  ColorsManager.primaryPurple,
                ),
                _buildColorSwatch('Primary Gold', ColorsManager.primaryGold),
                _buildColorSwatch(
                  'Background',
                  ColorsManager.getBackgroundColor(context),
                ),
                _buildColorSwatch(
                  'Card',
                  ColorsManager.getCardBackgroundColor(context),
                ),
                _buildColorSwatch(
                  'Primary Text',
                  ColorsManager.getPrimaryTextColor(context),
                ),
                _buildColorSwatch(
                  'Secondary Text',
                  ColorsManager.getSecondaryTextColor(context),
                ),
                _buildColorSwatch(
                  'Border',
                  ColorsManager.getBorderColor(context),
                ),
                _buildColorSwatch('Success', const Color.fromRGBO(76, 175, 80, 1)),
                _buildColorSwatch('Error', ColorsManager.error),
                _buildColorSwatch('Warning', ColorsManager.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorsManager.gray),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          name,
          style: TextStyle(fontSize: 10.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildComponentExamples(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Component Examples',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),

            // Buttons
            Wrap(
              spacing: 8.w,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                TextButton(onPressed: () {}, child: const Text('Text Button')),
              ],
            ),
            SizedBox(height: 16.h),

            // Input Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Sample Input',
                hintText: 'Enter some text...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),

            // Switch
            Row(
              children: [
                Text('Toggle Switch: '),
                Switch(value: true, onChanged: (value) {}),
              ],
            ),
            SizedBox(height: 16.h),

            // Chips
            Wrap(
              spacing: 8.w,
              children: [
                Chip(label: Text('Chip 1')),
                Chip(label: Text('Chip 2')),
                FilterChip(
                  label: Text('Filter Chip'),
                  selected: true,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIslamicContentExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Islamic Content Example',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),

            // Hadith Card
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorsManager.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: ColorsManager.primaryPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: ColorsManager.primaryPurple,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'حديث شريف',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.6,
                      color: ColorsManager.getPrimaryTextColor(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'صحيح البخاري',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorsManager.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Category Tags
            Wrap(
              spacing: 8.w,
              children: [
                _buildCategoryTag('الصلاة', ColorsManager.hadithAuthentic),
                _buildCategoryTag('الزكاة', ColorsManager.hadithGood),
                _buildCategoryTag('الصيام', ColorsManager.hadithWeak),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildThemeControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Controls',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),

            // Theme Mode Selection
            BlocBuilder<ThemeManager, ThemeMode>(
              builder: (context, themeMode) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Mode'),
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeManager>().setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark Mode'),
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeManager>().setThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('System'),
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<ThemeManager>().setThemeMode(value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 16.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<ThemeManager>().toggleTheme();
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Toggle Theme'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<ThemeManager>().resetToSystemTheme();
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
