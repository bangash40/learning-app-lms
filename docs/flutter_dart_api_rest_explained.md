# Flutter, Dart, API, and REST — Explained Using This App

This document explains four core concepts behind the **Learning App LMS** project, using
real code from this repository as examples rather than generic theory alone.

---

## 1. Flutter

**What it is:** Flutter is Google's UI toolkit for building apps from a single Dart codebase
that compile to native apps on Android, iOS, web, and desktop. Instead of wrapping a web view
or translating to each platform's native UI components, Flutter draws every pixel itself using
its own rendering engine (Skia/Impeller) — so a button looks and behaves identically on every
platform. That's why this project can target Android and iOS from one `lib/` folder.

**The core idea — everything is a widget:** In Flutter, the UI is a tree of "widgets," small
immutable configuration objects that describe what a piece of the screen should look like.
Flutter re-builds parts of that tree whenever data changes, and only re-draws what actually
changed.

Two kinds of widgets you'll see everywhere in this app:

- **`StatelessWidget`** — has no internal state that changes over time. It just takes some
  input and renders it. Example: [`lib/widgets/course_card.dart`](../lib/widgets/course_card.dart)
  — a `CourseCard` always renders the same way for the same `Course` object; it never changes
  itself.
- **`StatefulWidget`** — holds state that changes while the widget is on screen, and calls
  `setState()` to tell Flutter "re-render me." Example:
  [`lib/screens/quiz_screen.dart`](../lib/screens/quiz_screen.dart) — `_QuizAttemptState` holds
  which question you're on and what you've answered, and calls `setState()` every time you tap
  an option.

**The widget tree in this app**, simplified:

```
MaterialApp (lib/main.dart)
└── AuthGate (lib/screens/auth_gate.dart)      — picks Login vs Home based on auth state
    ├── LoginScreen / SignupScreen              — shown when signed out
    └── HomeScreen                              — shown when signed in
        └── CourseCard (one per course)
            └── CourseDetailScreen (pushed on tap)
                ├── LectureTile (one per lecture)
                │   └── VideoPlayerScreen (pushed on tap)
                └── QuizScreen (pushed on tap)
```

Every screen in `lib/screens/` and every reusable piece in `lib/widgets/` is a node in this
tree. Navigating between screens (`Navigator.of(context).push(...)`) pushes a new widget onto a
stack; the back button pops it off.

**Why Flutter fits this project:** the brief calls for one codebase that runs on both Android
and iOS with a polished, custom UI (course cards, video player controls, quiz feedback
colors) — exactly what Flutter is built for, versus something like a web-view wrapper which
would feel and perform worse.

---

## 2. Dart

**What it is:** Dart is the programming language Flutter apps are written in (also made by
Google). Every `.dart` file in `lib/` is Dart code. A few Dart features you'll see constantly in
this codebase:

**Classes and constructors** — most files define a class. Example, simplified from
[`lib/models/course.dart`](../lib/models/course.dart):

```dart
class Course {
  const Course({required this.id, required this.title, ...});
  final String id;
  final String title;
  ...
}
```

**Null safety** — Dart distinguishes types that can be `null` from ones that can't.
`String title` can never be null; `String?` could be. This is why
[`lib/models/course_progress.dart`](../lib/models/course_progress.dart) declares
`final int? quizScore;` — a course might not have a quiz result yet, so it's allowed to be
null, and the compiler forces every piece of code that reads it to handle that case.

**`Future` and `async`/`await`** — a `Future<T>` represents a value of type `T` that isn't
ready yet (e.g., still loading over the network). `async`/`await` let you write asynchronous
code that reads top-to-bottom instead of nesting callbacks. Example from
[`lib/services/lms_api_service.dart`](../lib/services/lms_api_service.dart):

```dart
Future<List<Course>> getCourses() async {
  final response = await _get(ApiConfig.courses()); // waits for the HTTP call
  final data = jsonDecode(response.body) as List;    // then runs this line
  return data.map((json) => Course.fromJson(json)).toList();
}
```

**`Stream`** — like a `Future` but can produce many values over time instead of just one.
Firebase auth state and Firestore progress data are both streams, because they can change at
any moment (someone signs out, a document updates) and the UI needs to react live. Example
from [`lib/screens/auth_gate.dart`](../lib/screens/auth_gate.dart):

```dart
StreamBuilder<User?>(
  stream: authService.authStateChanges, // fires every time sign-in state changes
  builder: (context, snapshot) => snapshot.hasData ? HomeScreen(...) : LoginScreen(...),
)
```

**Why Dart fits Flutter:** Dart compiles to native ARM/x64 machine code for release builds
(fast, like a compiled language) but also supports "hot reload" during development, where Dart
code changes appear in the running app in under a second without losing app state — a huge
reason Flutter development feels fast.

---

## 3. API (Application Programming Interface)

**What it is, generally:** an API is a defined way for one piece of software to ask another
piece of software to do something or hand over data, without needing to know how that other
piece works internally. You call a function or send a request; you get a result back.

**In this app specifically:** the "LMS API" is the boundary between the Flutter app and the
backend that owns course/lecture/quiz data. The app never touches a database directly — it
only ever talks to that API. This project's entire API integration is deliberately
concentrated in two files:

- [`lib/config/api_config.dart`](../lib/config/api_config.dart) — the API's address (base URL)
  and endpoint paths, in one place.
- [`lib/services/lms_api_service.dart`](../lib/services/lms_api_service.dart) — the only code
  in the app allowed to make HTTP calls. Every screen asks *this* for data; it never builds a
  URL or calls `http.get` itself.

This separation is why swapping the mock backend for the real Internee.pk LMS later should
only require editing `api_config.dart` — nothing in `lib/screens/` or `lib/widgets/` needs to
know or care where the data physically comes from.

---

## 4. REST (Representational State Transfer)

**What it is:** REST is a *style* of designing APIs over HTTP (the same protocol web browsers
use). A REST API exposes "resources" as URLs, and you act on them using standard HTTP methods:

| HTTP method | Meaning            | Used in this app? |
|---|---|---|
| `GET`    | Read a resource           | Yes — every request this app makes |
| `POST`   | Create a resource         | Not needed yet (the app only reads course data) |
| `PUT`/`PATCH` | Update a resource     | Not needed yet |
| `DELETE` | Remove a resource         | Not needed yet |

Responses are typically **JSON** — plain text formatted as nested objects/arrays/keys/values,
which is easy for both humans and machines to read.

**This app's actual REST endpoints** (served by the mock backend, `mock_backend/db.json`):

```
GET http://192.168.0.125:3000/courses                 → list of all courses
GET http://192.168.0.125:3000/courses/:id              → one course
GET http://192.168.0.125:3000/lectures?courseId=:id    → lectures belonging to a course
GET http://192.168.0.125:3000/quizzes?courseId=:id     → the quiz belonging to a course
```

`?courseId=1` is a **query parameter** — a REST filtering convention meaning "only give me
lectures/quizzes where the `courseId` field equals 1."

**Tracing one real request through the code**, from tap to screen:

1. You tap "Flutter for Beginners" on the course list
   ([`lib/screens/home_screen.dart`](../lib/screens/home_screen.dart)).
2. That navigates to `CourseDetailScreen`, whose `initState()` calls
   `widget.apiService.getLecturesForCourse(widget.course.id)`.
3. Inside [`lib/services/lms_api_service.dart`](../lib/services/lms_api_service.dart), that
   method builds the URL via `ApiConfig.lecturesForCourse(courseId)`, does an HTTP `GET`, and
   waits for a response.
4. The mock server (`json-server`, reading `mock_backend/db.json`) receives that HTTP request,
   filters its `lectures` array by `courseId`, and sends back a JSON array as the response body.
5. `LmsApiService` decodes that JSON (`jsonDecode`) and converts each JSON object into a
   `Lecture` object via `Lecture.fromJson(...)` (see
   [`lib/models/lecture.dart`](../lib/models/lecture.dart)) — this is the step where "raw text
   from the internet" becomes "a typed Dart object the rest of the app can safely use."
6. That `List<Lecture>` flows back up through the `Future`, and `CourseDetailScreen`'s
   `FutureBuilder` rebuilds the screen to show the lecture list.

**Why REST fits this project:** the brief requires the app to work "exactly like a real LMS"
over REST, with only the base URL differing between the mock backend and a real one. REST's
convention of "resources as URLs, JSON as the format" is exactly what lets `ApiConfig` be the
single point of change — a real LMS speaking REST/JSON is a drop-in replacement for
`json-server`.

---

## How these four fit together in this app

```
 [Dart language]  →  used to write  →  [Flutter widgets]  →  which call  →  [an API service]
                                                                                    │
                                                                     makes [REST] HTTP requests
                                                                                    │
                                                                                    ▼
                                                              mock backend (json-server + db.json)
```

Flutter/Dart build what you see and how it behaves; the API layer is the contract for getting
data; REST is the specific protocol that contract is implemented with, over plain HTTP and
JSON, so it can later point at a real server with no other code changes.

**See also:** the README's ["Running this on a different device or network"](../README.md#running-this-on-a-different-device-or-network)
section for the exact one-line change (`ApiConfig.baseUrl`) needed to run this app against a
different backend, emulator, physical device, or network.
