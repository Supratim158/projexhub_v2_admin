# 🛠️ ProjexHub Admin

A modern Flutter-based admin dashboard for managing projects, users, feedback, and AI-powered insights.

---

## 🧰 Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-State%20Management-800080?style=for-the-badge)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![HTTP](https://img.shields.io/badge/HTTP-Client-orange?style=for-the-badge)
![GetStorage](https://img.shields.io/badge/GetStorage-Local%20Storage-green?style=for-the-badge)
![Lottie](https://img.shields.io/badge/Lottie-Animations-ff69b4?style=for-the-badge)
![REST API](https://img.shields.io/badge/API-REST-blue?style=for-the-badge)

---

## 📖 Description

**ProjexHub Admin** is a responsive admin dashboard built using Flutter and GetX.  
It allows administrators to manage projects, users, feedback, and perform **AI-powered project analysis**.

The app is designed for:
- Web (Primary)
- Mobile & Desktop (Optional)

---

## ✨ Features

- 🔐 **Authentication**
  - Secure login/logout
  - Token storage using GetStorage

- 📊 **Dashboard**
  - Overview statistics
  - Quick insights and metrics

- 📁 **Project Management**
  - View projects (Pending / Approved / Rejected)
  - Approve or reject submissions
  - View project details, images, and comments

- 🤖 **AI Analyzer**
  - Auto project summary
  - Project scoring
  - AI-based Q&A

- 💬 **Feedback System**
  - View and manage user feedback

- 👥 **User Management**
  - List and manage users

- ⚙️ **Settings**
  - Admin configuration panel

- 🎨 **UI/UX**
  - Sidebar navigation
  - Responsive design
  - Lottie animations

---

## 🏗️ Architecture

- **Framework:** Flutter + GetX (MVC Pattern)
- **Controllers:** LoginController, ProjectController, AIController
- **Storage:** GetStorage
- **API:** REST APIs via HTTP
- **Animations:** Lottie
- **Localization:** intl package

---

## 📁 Folder Structure

```
lib/
├── constants/       
├── controllers/     
├── core/            
├── models/          
├── screens/         
└── widgets/         
```

---

## 📸 Screenshots

> ⚠️ Add real screenshots after running the app

| Screen | Preview |
|--------|--------|
| Login | ![Login](assets/images/logo.png) |
| Dashboard | *(Add screenshot)* |
| Project Details | *(Add screenshot)* |
| AI Analyzer | *(Add screenshot)* |

---

## 🚀 Quick Start

### 🔧 Prerequisites

- Flutter SDK (^3.5.3+)
- Dart SDK (^3.5.3+)
- Backend API running
- Chrome (for web)

---

### 📥 Installation

```bash
git clone <your-repo-url>
cd projexhub_v2_admin
flutter pub get
```

---

### ▶️ Run the App

```bash
flutter run -d chrome
```

---

### 🔑 Login

Use admin credentials from your backend.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_vector_icons:
  get: ^4.7.3
  lottie:
  http:
  get_storage:
  url_launcher:
  intl:
```

---

## 🔌 Backend API Requirements

Expected endpoints:

- `POST /login`
- `GET /projects?status=pending`
- `POST /projects/{id}/approve`
- `POST /projects/{id}/reject`
- `POST /ai/summary/{projectId}`
- `POST /ai/score`
- `POST /ai/question`
- `GET /comments/{projectId}`
- `POST /comments`
- `GET /users`
- `GET /feedback`
- `GET /dashboard/stats`

---

## 🤝 Contributing

1. Fork the repo  
2. Create a branch  
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit changes  
4. Push to GitHub  
5. Open a Pull Request  

---

## 📄 License

MIT License

---

## 🙏 Acknowledgments

- Flutter  
- GetX  
- LottieFiles  

---

⭐ Star the repo if you like it!
