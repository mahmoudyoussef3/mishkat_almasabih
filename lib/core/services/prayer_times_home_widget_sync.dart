import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimesHomeWidgetSync {
  static const String _locationKey = 'prayer_notification_location';
  static const String _legacyLocationKey = 'prayer_location';

  static Future<void> refresh() async {
    try {
      final location = await _resolveLocation();
      final now = DateTime.now();
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;

      final prayerTimes = PrayerTimes(
        Coordinates(location.latitude, location.longitude),
        DateComponents.from(now),
        params,
      );

      final prayers = <_PrayerItem>[
        _PrayerItem('fajr', 'الفجر', prayerTimes.fajr),
        _PrayerItem('sunrise', 'الشروق', prayerTimes.sunrise),
        _PrayerItem('dhuhr', 'الظهر', prayerTimes.dhuhr),
        _PrayerItem('asr', 'العصر', prayerTimes.asr),
        _PrayerItem('maghrib', 'المغرب', prayerTimes.maghrib),
        _PrayerItem('isha', 'العشاء', prayerTimes.isha),
      ];

      final next = _resolveNextPrayer(prayers, now);
      final hijriDate = _formatHijriDate(now);
      final gregorianDate = _formatGregorianDate(now);

      await HomeWidget.saveWidgetData<String>('prayer_hijri_date', hijriDate);
      await HomeWidget.saveWidgetData<String>(
        'prayer_gregorian_date',
        gregorianDate,
      );

      await HomeWidget.saveWidgetData<String>(
        'prayer_fajr',
        _formatTime(prayerTimes.fajr),
      );
      await HomeWidget.saveWidgetData<String>(
        'prayer_sunrise',
        _formatTime(prayerTimes.sunrise),
      );
      await HomeWidget.saveWidgetData<String>(
        'prayer_dhuhr',
        _formatTime(prayerTimes.dhuhr),
      );
      await HomeWidget.saveWidgetData<String>(
        'prayer_asr',
        _formatTime(prayerTimes.asr),
      );
      await HomeWidget.saveWidgetData<String>(
        'prayer_maghrib',
        _formatTime(prayerTimes.maghrib),
      );
      await HomeWidget.saveWidgetData<String>(
        'prayer_isha',
        _formatTime(prayerTimes.isha),
      );

      await HomeWidget.saveWidgetData<String>('prayer_next_key', next.key);

      await HomeWidget.updateWidget(
        name: 'PrayerTimesWidgetProvider',
        iOSName: 'PrayerTimesWidget',
      );
    } catch (_) {
      // Avoid affecting app bootstrap if widget update fails.
    }
  }

  static _PrayerItem _resolveNextPrayer(
    List<_PrayerItem> prayers,
    DateTime now,
  ) {
    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }

    final fajr = prayers.firstWhere((prayer) => prayer.key == 'fajr');
    return _PrayerItem(
      fajr.key,
      'الفجر',
      fajr.time.add(const Duration(days: 1)),
    );
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _arabicWeekday(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'الاثنين',
      DateTime.tuesday => 'الثلاثاء',
      DateTime.wednesday => 'الأربعاء',
      DateTime.thursday => 'الخميس',
      DateTime.friday => 'الجمعة',
      DateTime.saturday => 'السبت',
      DateTime.sunday => 'الأحد',
      _ => 'اليوم',
    };
  }

  static String _formatHijriDate(DateTime now) {
    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.fromDate(now);
    return '${_toArabicNumerals(hijri.hDay)} ${hijri.getLongMonthName()} ${_toArabicNumerals(hijri.hYear)} هـ';
  }

  static String _formatGregorianDate(DateTime now) {
    final months = <String>[
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return '${_arabicWeekday(now.weekday)}، ${_toArabicNumerals(now.day)} ${months[now.month - 1]} ${_toArabicNumerals(now.year)} م';
  }

  static String _toArabicNumerals(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicDigits[int.parse(digit)])
        .join();
  }

  static Future<_WidgetLocation> _resolveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString(_locationKey) ?? prefs.getString(_legacyLocationKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return _WidgetLocation(
          latitude: (json['latitude'] as num?)?.toDouble() ?? 30.0444,
          longitude: (json['longitude'] as num?)?.toDouble() ?? 31.2357,
          cityName:
              (json['cityName'] as String?)?.trim().isNotEmpty == true
                  ? json['cityName'] as String
                  : 'القاهرة، مصر',
        );
      } catch (_) {
        // Fall back to default location.
      }
    }

    return const _WidgetLocation(
      latitude: 30.0444,
      longitude: 31.2357,
      cityName: 'القاهرة، مصر',
    );
  }
}

class _PrayerItem {
  final String key;
  final String label;
  final DateTime time;

  const _PrayerItem(this.key, this.label, this.time);
}

class _WidgetLocation {
  final double latitude;
  final double longitude;
  final String cityName;

  const _WidgetLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });
}
