# 📚 Learning App LMS

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

The official Internee.pk LMS API isn't available, so this app talks to a mock REST backend
(json-server) instead — see [`mock_backend/README.md`](mock_backend/README.md) for setup and
the exact JSON schema. Only the base URL in `lib/config/api_config.dart` differs from a real
LMS; the REST service layer, models, and every screen work exactly the same either way, so
swapping in the real Internee.pk API later needs no other code changes.

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
- [Node.js](https://nodejs.org) (to run the mock REST backend)
- An IDE (VS Code or Android Studio)
- A [Firebase](https://console.firebase.google.com) project with **Authentication**
  (Email/Password) and **Firestore Database** enabled
- A device or emulator to run the app

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/bangash40/learning-app-lms.git
cd learning-app-lms

# 2. Install dependencies
flutter pub get

# 3. Add your Firebase config
#    - android/app/google-services.json
#    - ios/Runner/GoogleService-Info.plist
#    - Run `flutterfire configure` to generate lib/config/firebase_options.dart
#      (or fill it in by hand — see the comments in that file)

# 4. Publish firestore.rules to your Firebase project
#    (Firestore Database > Rules tab, paste the contents of firestore.rules)

# 5. Start the mock LMS backend (see mock_backend/README.md for details)
cd mock_backend && npx json-server@0.17.4 db.json --port 3000 && cd ..

# 6. Point the app at your backend in lib/config/api_config.dart (ApiConfig.baseUrl),
#    then run the app
flutter run
```

---

## 🗺️ Development Roadmap

This app is built in clear, self-contained steps (one step ≈ one commit):

- [x] **Step 1** — Project setup (Flutter project, folder structure, git, README)
- [x] **Step 2** — Firebase authentication (sign up / log in / log out)
- [x] **Step 3** — LMS REST API integration layer (services + models)
- [x] **Step 4** — Course browsing UI (listings + course detail)
- [x] **Step 5** — Integrated video player
- [x] **Step 6** — Quizzes with real-time scoring
- [x] **Step 7** — Progress tracking (Firebase-backed)
- [x] **Step 8** — Final integration & polish

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