import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final socialLinks = [
      {
        'icon': FontAwesomeIcons.whatsapp,
        'url': 'https://whatsapp.com/channel/0029VazdI4N84OmAWA8h4S2F',
        'color': Colors.green,
      },
      {
        'icon': FontAwesomeIcons.instagram,
        'url': 'https://www.instagram.com/mishkahcom1',
        'color': Colors.red,
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'url': 'https://x.com/mishkahcom1',
        'color': Colors.black,
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'url': 'https://www.facebook.com/mishkahcom1',
        'color': Colors.blue,
      },
      {
        'icon': FontAwesomeIcons.envelope,
        'url': 'mailto:Meshkah@hadith-shareef.com',
        'color': Colors.redAccent,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
      decoration: BoxDecoration(
      
        color: ColorsManager.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.mediumGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: socialLinks.map((link) {
          return GestureDetector(
            onTap: () => _launchUrl(link['url'] as String),
            child: Icon(
              link['icon'] as IconData,
              size: 28,
              color: link['color'] as Color,
            ),
          );
        }).toList(),
      ),
    );
  }
}
