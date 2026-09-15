# 📚 LMS Learning App

A cross-platform mobile application that gives users easy access to LMS courses and learning
resources. Browse courses, watch video lectures through an integrated player, and attempt
quizzes with real-time scoring and progress tracking — all in one smooth, interactive
learning experience built for students and interns.

---

## ✨ Features

- **Course browsing** — Browse course listings pulled from an LMS platform over REST.
- **Integrated video player** — Watch video lectures directly inside the app.
- **Quizzes with real-time scoring** — Attempt quizzes and see your score update as you answer.
- **Progress tracking** — Track your learning and quiz progress, backed by Firebase.
- **Authentication** — Secure sign up, log in, and log out via Firebase.

---

## 🛠️ Tech Stack

| Layer            | Technology                                  |
| ---------------- | ------------------------------------------- |
| Mobile framework | [Flutter](https://flutter.dev) (cross-platform) |
| LMS integration  | REST APIs                                    |
| Auth & backend   | [Firebase](https://firebase.google.com)     |

---

## 📖 About the Data Source

This project is designed to connect to an LMS platform over REST for course access and quiz
management.


---

## 📂 Project Structure

```
lib/
├── config/      # Configurable constants (API base URL, endpoint paths)
├── models/      # Data models (Course, Lecture, Quiz)
├── services/    # REST API service layer + Firebase logic
├── screens/     # UI screens
└── widgets/     # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- An IDE (VS Code or Android Studio)
- A [Firebase](https://console.firebase.google.com) project
- A device or emulator to run the app

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/bangash40/lms-learning-app.git
cd lms-learning-app

# 2. Install dependencies
flutter pub get

# 3. Add your Firebase config files
#    - android/app/google-services.json
#    - ios/Runner/GoogleService-Info.plist

# 4. Run the app
flutter run
```

> **Note:** Set your REST API base URL in `lib/config/` before running, so the app can fetch
> courses, lectures, and quizzes.

---

## 🗺️ Development Roadmap

This app is built in clear, self-contained steps (one step ≈ one commit):

- [x] **Step 1** — Project setup (Flutter project, folder structure, git, README)
- [x] **Step 2** — Firebase authentication (sign up / log in / log out)
- [x] **Step 3** — LMS REST API integration layer (services + models)
- [x] **Step 4** — Course browsing UI (listings + course detail)
- [ ] **Step 5** — Integrated video player
- [ ] **Step 6** — Quizzes with real-time scoring
- [ ] **Step 7** — Progress tracking (Firebase-backed)
- [ ] **Step 8** — Final integration & polish

---

## 📱 Screenshots

_Screenshots will be added as the app is developed._

<!--
| Home | Course Detail | Quiz |
| ---- | ------------- | ---- |
| ...  | ...           | ...  |
-->

---

## 🤝 Contributing

This is a personal / learning project. Suggestions and feedback are welcome via issues.

---

## 👤 Author

**Farhan Bangash**