# Islamic Library 17 Books - API Endpoints with Authentication

## 📚 Overview
This document outlines the API endpoints for the 17 books Islamic library (مشكاة المصابيح) with integrated authentication. The library contains authentic Islamic texts including Hadith collections, Quranic studies, and Islamic jurisprudence.

## 🔐 Authentication Endpoints

### Login
```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "refresh_token_here",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": 1,
    "name": "User Name",
    "email": "user@example.com",
    "role": "user"
  }
}
```

### Register
```
POST /api/auth/register
Content-Type: application/json

{
  "name": "User Name",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

### Refresh Token
```
POST /api/auth/refresh
Authorization: Bearer {refresh_token}

Response:
{
  "access_token": "new_access_token",
  "expires_in": 3600
}
```

### Logout
```
POST /api/auth/logout
Authorization: Bearer {access_token}
```

## 📖 Library Content Endpoints

### 1. Get All Books
```
GET /api/books
Authorization: Bearer {access_token}

Response:
{
  "data": [
    {
      "id": 1,
      "title": "صحيح البخاري",
      "title_en": "Sahih Al-Bukhari",
      "author": "محمد بن إسماعيل البخاري",
      "author_en": "Muhammad ibn Ismail al-Bukhari",
      "category": "hadith",
      "description": "One of the six major hadith collections",
      "total_hadith": 7563,
      "language": "ar",
      "status": "active"
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 17,
    "per_page": 20
  }
}
```

### 2. Get Book Details
```
GET /api/books/{book_id}
Authorization: Bearer {access_token}

Response:
{
  "data": {
    "id": 1,
    "title": "صحيح البخاري",
    "title_en": "Sahih Al-Bukhari",
    "author": "محمد بن إسماعيل البخاري",
    "author_en": "Muhammad ibn Ismail al-Bukhari",
    "category": "hadith",
    "description": "One of the six major hadith collections",
    "total_hadith": 7563,
    "language": "ar",
    "chapters": [
      {
        "id": 1,
        "title": "كتاب بدء الوحي",
        "title_en": "Book of Revelation",
        "hadith_count": 6
      }
    ],
    "status": "active"
  }
}
```

### 3. Get Book Chapters
```
GET /api/books/{book_id}/chapters
Authorization: Bearer {access_token}
Query Parameters:
- page: 1
- per_page: 50
- language: ar|en

Response:
{
  "data": [
    {
      "id": 1,
      "title": "كتاب بدء الوحي",
      "title_en": "Book of Revelation",
      "hadith_count": 6,
      "order": 1
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 97,
    "per_page": 50
  }
}
```

### 4. Get Chapter Hadith
```
GET /api/books/{book_id}/chapters/{chapter_id}/hadith
Authorization: Bearer {access_token}
Query Parameters:
- page: 1
- per_page: 20
- language: ar|en

Response:
{
  "data": [
    {
      "id": 1,
      "number": 1,
      "arabic_text": "حدثنا الحميدي عبد الله بن الزبير قال حدثنا سفيان قال حدثنا يحيى بن سعيد الأنصاري قال أخبرني محمد بن إبراهيم التيمي أنه سمع علقمة بن وقاص الليثي يقول سمعت عمر بن الخطاب رضي الله عنه على المنبر قال سمعت رسول الله صلى الله عليه وسلم يقول إنما الأعمال بالنيات وإنما لكل امرئ ما نوى فمن كانت هجرته إلى دنيا يصيبها أو إلى امرأة ينكحها فهجرته إلى ما هاجر إليه",
      "english_text": "Narrated 'Umar bin Al-Khattab: I heard Allah's Messenger (ﷺ) saying, 'The reward of deeds depends upon the intentions and every person will get the reward according to what he has intended...'",
      "narrator": "عمر بن الخطاب",
      "narrator_en": "Umar ibn Al-Khattab",
      "authenticity": "صحيح",
      "authenticity_en": "Authentic",
      "category": "faith",
      "tags": ["intention", "migration", "reward"]
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 6,
    "per_page": 20
  }
}
```

### 5. Search Hadith
```
GET /api/search/hadith
Authorization: Bearer {access_token}
Query Parameters:
- q: "search term"
- book_id: 1
- chapter_id: 1
- narrator: "narrator name"
- authenticity: "صحيح|حسن|ضعيف"
- category: "faith|worship|social"
- language: "ar|en"
- page: 1
- per_page: 20

Response:
{
  "data": [
    {
      "id": 1,
      "book": {
        "id": 1,
        "title": "صحيح البخاري"
      },
      "chapter": {
        "id": 1,
        "title": "كتاب بدء الوحي"
      },
      "hadith": {
        "id": 1,
        "number": 1,
        "arabic_text": "حدثنا الحميدي...",
        "english_text": "Narrated 'Umar...",
        "narrator": "عمر بن الخطاب",
        "authenticity": "صحيح"
      },
      "relevance_score": 0.95
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 150,
    "per_page": 20
  }
}
```

### 6. Get Daily Hadith
```
GET /api/hadith/daily
Authorization: Bearer {access_token}

Response:
{
  "data": {
    "id": 1,
    "date": "2024-01-15",
    "hadith": {
      "id": 1,
      "book": "صحيح البخاري",
      "chapter": "كتاب بدء الوحي",
      "arabic_text": "حدثنا الحميدي...",
      "english_text": "Narrated 'Umar...",
      "narrator": "عمر بن الخطاب",
      "authenticity": "صحيح"
    }
  }
}
```

### 7. Get Random Hadith
```
GET /api/hadith/random
Authorization: Bearer {access_token}
Query Parameters:
- book_id: 1 (optional)
- category: "faith" (optional)

Response:
{
  "data": {
    "id": 1,
    "book": "صحيح البخاري",
    "chapter": "كتاب بدء الوحي",
    "arabic_text": "حدثنا الحميدي...",
    "english_text": "Narrated 'Umar...",
    "narrator": "عمر بن الخطاب",
    "authenticity": "صحيح"
  }
}
```

## 🔖 User Content Management

### 8. Add Bookmark
```
POST /api/bookmarks
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "content_type": "hadith",
  "content_id": 1,
  "note": "Important hadith about intention"
}

Response:
{
  "data": {
    "id": 1,
    "content_type": "hadith",
    "content_id": 1,
    "note": "Important hadith about intention",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### 9. Get User Bookmarks
```
GET /api/bookmarks
Authorization: Bearer {access_token}
Query Parameters:
- content_type: "hadith|book|chapter"
- page: 1
- per_page: 20

Response:
{
  "data": [
    {
      "id": 1,
      "content_type": "hadith",
      "content": {
        "id": 1,
        "book": "صحيح البخاري",
        "chapter": "كتاب بدء الوحي",
        "arabic_text": "حدثنا الحميدي...",
        "english_text": "Narrated 'Umar...",
        "narrator": "عمر بن الخطاب"
      },
      "note": "Important hadith about intention",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 25,
    "per_page": 20
  }
}
```

### 10. Update Reading Progress
```
PUT /api/progress/{book_id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "chapter_id": 1,
  "hadith_number": 5,
  "percentage": 25.5
}

Response:
{
  "data": {
    "book_id": 1,
    "chapter_id": 1,
    "hadith_number": 5,
    "percentage": 25.5,
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

## 📊 Analytics & Statistics

### 11. Get User Reading Stats
```
GET /api/analytics/reading
Authorization: Bearer {access_token}
Query Parameters:
- period: "week|month|year"
- book_id: 1 (optional)

Response:
{
  "data": {
    "total_hadith_read": 150,
    "total_time_spent": 3600,
    "books_progress": [
      {
        "book_id": 1,
        "book_title": "صحيح البخاري",
        "progress_percentage": 25.5,
        "hadith_read": 150,
        "total_hadith": 7563
      }
    ],
    "daily_average": 5.2,
    "streak_days": 7
  }
}
```

## 🌐 Content Discovery

### 12. Get Categories
```
GET /api/categories
Authorization: Bearer {access_token}

Response:
{
  "data": [
    {
      "id": 1,
      "name": "الإيمان",
      "name_en": "Faith",
      "description": "Hadiths related to faith and belief",
      "hadith_count": 1250,
      "icon": "faith_icon.png"
    }
  ]
}
```

### 13. Get Authors/Narrators
```
GET /api/narrators
Authorization: Bearer {access_token}
Query Parameters:
- search: "عمر"
- page: 1
- per_page: 20

Response:
{
  "data": [
    {
      "id": 1,
      "name": "عمر بن الخطاب",
      "name_en": "Umar ibn Al-Khattab",
      "title": "الخليفة الثاني",
      "title_en": "The Second Caliph",
      "hadith_count": 537,
      "biography": "Umar ibn Al-Khattab was the second caliph of Islam..."
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 150,
    "per_page": 20
  }
}
```

## 🔍 Advanced Search & Filters

### 14. Global Search
```
GET /api/search/global
Authorization: Bearer {access_token}
Query Parameters:
- q: "search term"
- type: "hadith|book|chapter|narrator"
- language: "ar|en"
- page: 1
- per_page: 20

Response:
{
  "data": {
    "hadith": [...],
    "books": [...],
    "chapters": [...],
    "narrators": [...]
  },
  "meta": {
    "total_results": 250,
    "search_time": 0.15
  }
}
```

### 15. Filter Hadith
```
GET /api/hadith/filter
Authorization: Bearer {access_token}
Query Parameters:
- book_ids: "1,2,3"
- chapter_ids: "1,2"
- narrator_ids: "1,2"
- authenticity: "صحيح|حسن"
- categories: "faith|worship"
- date_from: "2024-01-01"
- date_to: "2024-01-31"
- page: 1
- per_page: 20
```

## 📱 Mobile-Specific Endpoints

### 16. Get App Version
```
GET /api/app/version
Authorization: Bearer {access_token}

Response:
{
  "data": {
    "version": "1.0.0",
    "build_number": 1,
    "update_required": false,
    "update_url": "https://play.google.com/store/apps/details?id=com.example.app",
    "changelog": "Bug fixes and performance improvements"
  }
}
```

### 17. Get App Settings
```
GET /api/app/settings
Authorization: Bearer {access_token}

Response:
{
  "data": {
    "notifications": {
      "daily_hadith": true,
      "content_updates": true,
      "reminders": false
    },
    "display": {
      "theme": "auto",
      "font_size": "medium",
      "language": "ar"
    },
    "content": {
      "auto_download": false,
      "offline_mode": true
    }
  }
}
```

## 🚀 Implementation Notes

### Authentication Flow
1. User logs in/registers
2. Server returns JWT access token + refresh token
3. Client stores tokens securely
4. All API calls include `Authorization: Bearer {access_token}`
5. Token refresh happens automatically when access token expires

### Error Handling
```json
{
  "error": {
    "code": "AUTH_001",
    "message": "Invalid credentials",
    "details": "Email or password is incorrect"
  }
}
```

### Rate Limiting
- Authentication endpoints: 5 requests per minute
- Content endpoints: 100 requests per minute
- Search endpoints: 50 requests per minute

### Pagination
All list endpoints support pagination with:
- `page`: Current page number (starts from 1)
- `per_page`: Items per page (default: 20, max: 100)

### Language Support
- Primary: Arabic (ar)
- Secondary: English (en)
- Future: Urdu (ur), Indonesian (id), Turkish (tr)

---

**Note**: This API structure is designed for the Mishkat Al-Masabih Islamic Library app. All endpoints require authentication except for public content previews. The 17 books include major Hadith collections, Quranic studies, and Islamic jurisprudence texts.
