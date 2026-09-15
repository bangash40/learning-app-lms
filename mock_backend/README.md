# Mock LMS Backend

This folder is a stand-in for the real Internee.pk LMS REST API. It exposes the same shape of
data (`courses`, `lectures`, `quizzes`) that the app's `LmsApiService` expects — only the base
URL differs from a real LMS (see `lib/config/api_config.dart`).

## Option A — Run it locally with json-server (recommended for development)

1. Install Node.js if you don't already have it.
2. From this `mock_backend/` folder, run:
   ```bash
   npx json-server@0.17.4 db.json --port 3000
   ```
   The version pin matters: `npx json-server` with no version installs the v1 rewrite, which
   silently drops support for `?field=value` query filtering — every filtered request (e.g.
   `GET /lectures?courseId=1`, which `LmsApiService` relies on) returns an empty array instead
   of an error, so the app loads courses but every course looks like it has no lectures/quiz.
   `0.17.4` is the last classic release and supports that filtering correctly.

   This starts a REST API at `http://localhost:3000` with `/courses`, `/lectures`, and
   `/quizzes` endpoints.
3. Point the app at it in `lib/config/api_config.dart`:
   - Android emulator: `http://10.0.2.2:3000`
   - iOS simulator: `http://localhost:3000`
   - Physical device: `http://<your-computer-LAN-IP>:3000` (same Wi-Fi network)

## Option B — Host it on mockapi.io

1. Create a free project at [mockapi.io](https://mockapi.io).
2. Create three resources named exactly `courses`, `lectures`, and `quizzes`.
3. For each resource, define the fields to match the schema in `db.json` (below), then paste
   in the sample records from `db.json` (mockapi.io's editor accepts JSON per record, or use
   its API to bulk-import).
4. Copy your project's base URL (looks like `https://<project-id>.mockapi.io/api/v1`) into
   `ApiConfig.baseUrl`.

   Note: mockapi.io's built-in filtering uses the same `?courseId=1` query-param style the app
   already sends, so no code changes are needed either way.

## Data schema

**courses**
| field | type | notes |
|---|---|---|
| id | string | |
| title | string | |
| description | string | |
| instructor | string | |
| category | string | e.g. "Mobile Development" |
| level | string | "Beginner" / "Intermediate" / "Advanced" |
| thumbnailUrl | string (URL) | |
| durationMinutes | number | total course duration |

**lectures**
| field | type | notes |
|---|---|---|
| id | string | |
| courseId | string | foreign key into `courses` |
| title | string | |
| videoUrl | string (URL) | free public sample MP4s (Big Buck Bunny, etc.) |
| durationMinutes | number | |
| order | number | position within the course, 1-based |

**quizzes**
| field | type | notes |
|---|---|---|
| id | string | |
| courseId | string | foreign key into `courses` |
| title | string | |
| questions | array | each item: `{ id, question, options: string[], correctOptionIndex }` |

## Swapping in the real LMS later

When the real Internee.pk LMS API is available, only `lib/config/api_config.dart` needs to
change (`baseUrl` and, if the paths differ, the `*Path` constants). `LmsApiService` and every
screen that uses it stay exactly the same, as long as the real API returns the same JSON shape
described above.
