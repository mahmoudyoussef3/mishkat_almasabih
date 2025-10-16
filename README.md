# 🕌 مشكاة الأحاديث - Mishkat Al-Ahadith

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B.svg?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2.svg?logo=dart)
![BLoC](https://img.shields.io/badge/BLoC-8.1.4-00B4AB.svg)
[![Google Play](https://img.shields.io/badge/Google_Play-Download-414141?logo=google-play)](https://play.google.com/store/apps/details?id=com.mishkat_almasabih.app&hl=ar)

**تطبيق مكتبة الأحاديث الإسلامية المصمم بعناية مع واجهة مستخدم جميلة**

**A beautifully designed Islamic Hadith library application built with Flutter**

[📥 حمّل من Google Play](https://play.google.com/store/apps/details?id=com.mishkat_almasabih.app&hl=ar)

</div>

---

## 📖 جدول المحتويات | Table of Contents

- [🌟 نظرة عامة | Overview](#-نظرة-عامة--overview)
- [✨ المميزات | Features](#-المميزات--features)
- [🏗️ البنية المعمارية | Architecture](#️-البنية-المعمارية--architecture)
- [🎨 نظام التصميم | Design System](#-نظام-التصميم--design-system)
- [📱 لقطات الشاشة | Screenshots](#-لقطات-الشاشة--screenshots)
- [🛠️ التقنيات المستخدمة | Tech Stack](#️-التقنيات-المستخدمة--tech-stack)
- [📁 هيكل المشروع | Project Structure](#-هيكل-المشروع--project-structure)
- [🚀 البدء | Getting Started](#-البدء--getting-started)
- [📚 التوثيق | Documentation](#-التوثيق--documentation)
- [🤝 المساهمة | Contributing](#-المساهمة--contributing)

---

## 🌟 نظرة عامة | Overview

**مشكاة الأحاديث** تطبيق شامل لمكتبة الأحاديث الإسلامية يوفر للمستخدمين الوصول إلى النصوص الإسلامية الأصيلة، والأحاديث اليومية، وتجربة قراءة جميلة. يتبع التطبيق مبادئ هندسة البرمجيات الحديثة ويطبق نظام تصميم إسلامي رائع.

**Mishkat Al-Ahadith** is a comprehensive Islamic Hadith library application that provides users with access to authentic Islamic texts, daily hadiths, and a beautiful reading experience. The app follows modern software engineering principles and implements a stunning Islamic-themed design system.

### 🎯 **أبرز النقاط | Key Highlights**
- 📚 **17 كتابًا إسلاميًا رئيسيًا** مع محتوى شامل
- 🎨 **تصميم إسلامي جميل** بألوان البنفسجي والذهبي
- 🏛️ **بنية معمارية نظيفة** تتبع مبادئ SOLID
- 🔄 **إدارة الحالة** باستخدام نمط BLoC
- 📱 **تصميم متجاوب** محسّن لجميع الأجهزة
- 🔤 **دعم اللغة العربية بشكل كامل** مع الاتجاه الصحيح للنص
- 💾 **إمكانيات غير متصلة بالإنترنت** مع تخزين البيانات محليًا

---

## ✨ المميزات | Features

### 📚 **مميزات المكتبة الأساسية | Core Library Features**
- **حديث اليوم**: حديث جديد كل يوم مع الشرح
- **تصنيفات الكتب**: منظمة حسب المواضيع الإسلامية
- **التنقل بين الأبواب**: تصفح سهل عبر أبواب الكتب
- **وظيفة البحث**: بحث متقدم عبر جميع المحتويات
- **نظام الإشارات المرجعية**: حفظ الأحاديث والمقاطع المفضلة
- **تتبع تقدم القراءة**: تابع رحلتك في القراءة

### 🔐 **المصادقة وإدارة المستخدم | Authentication & User Management**
- **تسجيل المستخدم**: إنشاء حساب آمن
- **نظام تسجيل الدخول**: طرق مصادقة متعددة
- **تسجيل الدخول بجوجل**: تكامل OAuth
- **إدارة الملف الشخصي**: تفضيلات وإعدادات المستخدم
- **مزامنة البيانات**: نسخ احتياطي ومزامنة سحابية

### 🎨 **مميزات تجربة المستخدم | User Experience Features**
- **تصميم إسلامي**: جماليات ثقافية أصيلة
- **الوضع الداكن/الفاتح**: قراءة مريحة في أي بيئة
- **تخطيط متجاوب**: محسّن لجميع أحجام الشاشات
- **رسوم متحركة سلسة**: تفاعلات محسّنة للمستخدم
- **إمكانية الوصول**: دعم قارئ الشاشة والتباين العالي

### 📱 **المميزات التقنية | Technical Features**
- **القراءة بدون إنترنت**: تنزيل المحتوى للوصول دون اتصال
- **إشعارات الدفع**: تذكيرات الحديث اليومي
- **وظيفة المشاركة**: مشاركة الأحاديث مع الآخرين
- **دعم متعدد اللغات**: واجهات عربية وإنجليزية
- **أداء محسّن**: تحميل سريع وتمرير سلس

---

## 🏗️ البنية المعمارية | Architecture

### **تطبيق البنية النظيفة | Clean Architecture Implementation**

يتبع التطبيق مبادئ **البنية النظيفة** مع تنظيم **يركز على الميزات**، مما يضمن قابلية الصيانة، وقابلية التوسع، والاختبار.

The app follows **Clean Architecture** principles with a **Feature-First** organization, ensuring maintainability, scalability, and testability.
```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│                        طبقة العرض                           │
├─────────────────────────────────────────────────────────────┤
│  • Screens (UI) | الشاشات                                  │
│  • Widgets (Reusable Components) | المكونات القابلة لإعادة الاستخدام │
│  • BLoC Cubits (State Management) | إدارة الحالة           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  BUSINESS LOGIC LAYER                       │
│                    طبقة منطق الأعمال                        │
├─────────────────────────────────────────────────────────────┤
│  • Use Cases | حالات الاستخدام                            │
│  • Business Rules | قواعد الأعمال                          │
│  • Validation Logic | منطق التحقق                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                            │
│                       طبقة البيانات                         │
├─────────────────────────────────────────────────────────────┤
│  • Repositories | المستودعات                               │
│  • Data Sources (API/Local) | مصادر البيانات               │
│  • Models | النماذج                                        │
└─────────────────────────────────────────────────────────────┘
```

### **إدارة الحالة باستخدام BLoC | State Management with BLoC**

- **تدفق حالة يمكن التنبؤ به**: تدفق واضح من الحدث → الحالة → واجهة المستخدم
- **فصل الاهتمامات**: منطق الأعمال معزول عن واجهة المستخدم
- **قابلية الاختبار**: سهولة اختبار منطق الأعمال بشكل مستقل
- **قابلية التوسع**: سهولة إضافة ميزات وحالات جديدة

### **حقن التبعية | Dependency Injection**

- **حاوية GetIt**: إدارة التبعيات المركزية
- **التحميل الكسول**: تهيئة الخدمات فقط عند الحاجة
- **قابلية الاختبار**: سهولة محاكاة التبعيات للاختبار
- **اقتران فضفاض**: يمكن استبدال المكونات بسهولة

---

## 🎨 نظام التصميم | Design System

### **لوحة الألوان الإسلامية | Islamic Color Palette**

نظام التصميم الخاص بنا مبني على الجماليات الإسلامية الأصيلة:

Our design system is built around authentic Islamic aesthetics:
```dart
// Primary Colors | الألوان الأساسية
primaryPurple: #7440E9    // اللون الرئيسي للعلامة التجارية
primaryGold: #FFB300      // لمسات ذهبية إسلامية
secondaryPurple: #9D7BF0  // تنوعات بنفسجية فاتحة

// Semantic Colors | الألوان الدلالية
hadithAuthentic: #4CAF50  // صحيح - أخضر
hadithGood: #9C27B0       // حسن - بنفسجي
hadithWeak: #FF9800       // ضعيف - برتقالي
```

### **نظام الطباعة | Typography System**

- **الخط الأساسي**: Amiri (محسّن للعربية)
- **الخط الاحتياطي**: YaModernPro
- **الحجم المتجاوب**: استخدام ScreenUtil لطباعة تكيفية
- **أنماط هرمية**: تسلسل هرمي واضح للنص لقراءة أفضل

### **تصميم المكونات | Component Design**

- **تخطيط قائم على البطاقات**: عرض معلومات نظيف ومنظم
- **أنماط إسلامية**: تراكبات هندسية دقيقة
- **خلفيات متدرجة**: انتقالات ألوان جميلة
- **ظلال محسّنة**: عمق وتسلسل هرمي بصري
- **زوايا مستديرة**: مظهر حديث وودود

---

## 📱 لقطات الشاشة | Screenshots

<div align="center">

### الشاشة الرئيسية | Home Screen
<img src="screenshots/home.webp" width="250" alt="Home Screen"/>

### المكتبة | Library
<img src="screenshots/library.webp" width="250" alt="Library"/>

### الكتب | Books
<img src="screenshots/books.webp" width="250" alt="Books"/>

### الأبواب | Chapters
<img src="screenshots/chapters.webp" width="250" alt="Chapters"/>

### الأحاديث | Ahadith
<img src="screenshots/ahadith.webp" width="250" alt="Ahadith"/>

### تفاصيل الحديث | Hadith Details
<img src="screenshots/hadith_details.webp" width="250" alt="Hadith Details"/>

### نتائج البحث | Search Results
<img src="screenshots/search_result.png" width="250" alt="Search Results"/>

### حديث اليوم | Hadith of the Day
<img src="screenshots/hadith_of_th_day.webp" width="250" alt="Hadith of the Day"/>

</div>

---

## 🛠️ التقنيات المستخدمة | Tech Stack

### **إطار الواجهة الأمامية | Frontend Framework**
- **Flutter 3.7+**: تطوير تطبيقات متعددة المنصات
- **Dart 3.7+**: لغة برمجة حديثة وآمنة من حيث النوع

### **إدارة الحالة | State Management**
- **flutter_bloc 8.1.4**: إدارة حالة يمكن التنبؤ بها
- **get_it 7.6.7**: حاوية حقن التبعية

### **الشبكات والـ API | Networking & API**
- **Dio 5.0.0**: عميل HTTP مع اعتراضات
- **Retrofit 4.0.3**: عميل HTTP آمن من حيث النوع
- **pretty_dio_logger 1.3.1**: تسجيل API جميل

### **واجهة المستخدم والتصميم | UI & Design**
- **flutter_screenutil 5.9.0**: أدوات تصميم متجاوب
- **flutter_animate 4.5.2**: رسوم متحركة سلسة
- **shimmer 3.0.0**: رسوم متحركة لحالة التحميل
- **flutter_svg 2.2.0**: دعم الرسومات المتجهة

### **البيانات والتخزين | Data & Storage**
- **shared_preferences 2.5.3**: استمرارية البيانات المحلية
- **dartz 0.10.1**: أدوات البرمجة الوظيفية

### **المصادقة | Authentication**
- **google_sign_in 6.2.2**: تكامل OAuth
- **permission_handler 12.0.1**: أذونات الجهاز

---

## 📁 هيكل المشروع | Project Structure
```
lib/
├── core/                           # طبقة التطبيق الأساسية | Core application layer
│   ├── di/                        # حقن التبعية | Dependency injection
│   ├── helpers/                   # وظائف مساعدة | Utility functions
│   ├── networking/                # طبقة API و HTTP | API and HTTP layer
│   ├── routing/                   # إدارة التنقل | Navigation management
│   ├── theming/                   # السمات والأنماط | Themes and styling
│   └── widgets/                   # مكونات مشتركة | Shared components
├── features/                      # وحدات الميزات | Feature modules
│   ├── authentication/            # تدفقات تسجيل الدخول/الاشتراك
│   ├── home/                     # لوحة التحكم الرئيسية
│   ├── hadith_daily/             # ميزة حديث اليوم
│   ├── hadith_details/           # عروض تفاصيل الحديث
│   ├── library/                  # إدارة مكتبة الكتب
│   ├── bookmark/                 # نظام الإشارات المرجعية
│   ├── search/                   # وظيفة البحث
│   ├── profile/                  # إدارة ملف المستخدم
│   ├── chapters/                 # التنقل في الأبواب
│   ├── ahadith/                  # محتوى الأحاديث
│   ├── book_data/                # معلومات الكتب
│   ├── navigation/               # منطق التنقل
│   ├── notification/             # إشعارات الدفع
│   ├── main_navigation/          # التنقل السفلي
│   ├── onboarding/               # تأهيل المستخدم
│   └── splash/                   # شاشة البداية
├── main_development.dart          # نقطة دخول التطوير
├── main_production.dart           # نقطة دخول الإنتاج
└── mishkat_almasabih.dart        # تكوين التطبيق الرئيسي
```

### **هيكل وحدة الميزة | Feature Module Structure**

تتبع كل ميزة هيكلًا متسقًا:

Each feature follows a consistent structure:
```
feature_name/
├── data/                          # طبقة البيانات | Data layer
│   ├── models/                    # نماذج البيانات | Data models
│   ├── repos/                     # تطبيقات المستودع | Repository implementations
│   └── datasources/               # مصادر بيانات API والمحلية
├── logic/                         # طبقة منطق الأعمال | Business logic layer
│   └── cubit/                     # BLoC cubits
└── ui/                            # طبقة العرض | Presentation layer
    ├── screens/                   # الشاشات الرئيسية | Main screens
    └── widgets/                   # ويدجت خاصة بالميزة | Feature-specific widgets
```

---

## 🚀 البدء | Getting Started

### **المتطلبات الأساسية | Prerequisites**

- Flutter SDK 3.7.0 أو أعلى
- Dart SDK 3.7.0 أو أعلى
- Android Studio / VS Code
- Git

### **التثبيت | Installation**
```bash
# 1. استنساخ المستودع | Clone the repository
git clone https://github.com/mahmoudyoussef3/mishkat_almasabih.git
cd mishkat-ahadith

# 2. تثبيت التبعيات | Install dependencies
flutter pub get

# 3. تشغيل التطبيق | Run the app
flutter run
```

### **إعداد البيئة | Environment Setup**

يدعم التطبيق بيئات متعددة:

The app supports multiple environments:

- **التطوير | Development**: `flutter run --flavor development`
- **الإنتاج | Production**: `flutter run --flavor production`

### **أوامر البناء | Build Commands**
```bash
# Android APK
flutter build apk 

# Android App Bundle (للنشر على Google Play)
flutter build appbundle

# iOS



## 🤝 المساهمة | Contributing

نرحب بالمساهمات من المجتمع! يرجى قراءة إرشادات المساهمة الخاصة بنا:

We welcome contributions from the community! Please read our contributing guidelines:

### **سير عمل التطوير | Development Workflow**

1. **Fork المستودع | Fork the repository**
2. **إنشاء فرع ميزة | Create a feature branch**
```bash
   git checkout -b feature/amazing-feature
```
3. **قم بإجراء تغييراتك | Make your changes**
4. **قم بالالتزام بتغييراتك | Commit your changes**
```bash
   git commit -m 'Add amazing feature'
```
5. **ادفع إلى الفرع | Push to the branch**
```bash
   git push origin feature/amazing-feature
```
6. **افتح طلب سحب | Open a Pull Request**

### **معايير الكود | Code Standards**

- اتبع **أفضل ممارسات Flutter**
- استخدم مبادئ **البنية النظيفة**
- حافظ على **اصطلاحات تسمية متسقة**
- اكتب **توثيقًا شاملاً**

---


## 🙏 شكر وتقدير | Acknowledgments

- **العلماء الإسلاميون**: للمحتوى الأصيل من الأحاديث
- **مجتمع Flutter**: لأدوات التطوير الممتازة
- **مصدر إلهام التصميم**: الفن والعمارة الإسلامية التقليدية
- **المساهمون**: جميع المطورين الذين ساهموا في هذا المشروع

---


## 🔗 روابط مهمة | Important Links

- [📥 تحميل من Google Play](https://play.google.com/store/apps/details?id=com.mishkat_almasabih.app&hl=ar)
- [🌐 الموقع الرسمي | Official Website](https://hadith-shareef.com/islamic-library)

---

<div align="center">

**صُنع بـ ❤️ للمجتمع الإسلامي | Made with ❤️ for the Islamic community**

*"طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ"*

*"Seeking knowledge is obligatory upon every Muslim" - Prophet Muhammad ﷺ*

---

### ⭐ إذا أعجبك المشروع، لا تنسَ إعطاءه نجمة!
### ⭐ If you like this project, don't forget to give it a star!

</div>