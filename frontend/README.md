# JongSart 🌿

A skincare / beauty clinic **booking app for Cambodia**, built with Flutter.

JongSart helps customers discover clinics, treatments, and doctors, then send an
**appointment request** to a clinic. As is normal in Cambodia, a booking is **not
confirmed instantly** — clinic staff review the request and contact the customer
to confirm, reschedule, or cancel.

> This project uses **mock / local data** and **shared_preferences** for storage.
> There is **no backend, no Firebase, and no complex authentication** yet.

> **Demo content notice:** All clinics, doctors, treatments, prices, reviews,
> promotions, and chat messages in this app are **fictional demo content** created
> for an MVP school project. They do not represent real clinics or real people.
> Content is **localized for Cambodia / Phnom Penh** (names, locations, and wording)
> to make the demo feel natural. Nothing in the app is medical advice — wording is
> kept safe ("consultation", "may help", "clinic staff will confirm suitability").

---

## Problem statement

In Cambodia, booking a skincare or beauty clinic is usually done by phone,
Telegram, or in person. There is rarely a single app where a customer can:

- browse clinics, treatments, and doctors,
- send a structured appointment request, and
- track the status of that request until the visit is complete.

JongSart models that real-world flow in a simple mobile app.

## Realistic clinic booking flow

```
Home
 → Search / Skin Profile / Promotions / Nearby Clinics
 → Treatment Detail or Clinic Detail or Doctor Profile
 → Book Consultation (fill in contact + preferences)
 → Submit Appointment Request
 → Status: Pending Confirmation
 → Clinic staff Confirm / Reschedule / Cancel
 → Status: Confirmed (customer visits clinic)
 → Status: Completed
 → Customer leaves a review
```

**Booking statuses:** Pending → Confirmed → Rescheduled → Cancelled → Completed.

## Main features

- 🏠 **Home** — welcome header, search, quick actions, skin-concern shortcuts,
  doctors, popular treatments, and a featured clinic banner.
- 🔍 **Search** — search treatments, clinics, and doctors with a friendly empty state.
- 🧴 **Treatment / Clinic / Doctor detail** — safe, non-medical wording
  ("may help with", "recommended consultation").
- 📝 **Book Consultation** — real form (name, phone, Telegram/WhatsApp, concern,
  clinic, treatment, optional doctor, date, time, note) with validation.
- 📅 **My Bookings** — all requests with status badges, cancel, and detail view.
- 📄 **Booking Detail** — full request info and status-aware actions
  (Chat / View Map / Leave Review / Book Again).
- 🧑‍⚕️ **Clinic Staff (Demo)** — mock admin screen to Confirm / Reschedule /
  Complete / Cancel requests. No backend — for presentation only.
- 💬 **Chat** — clinic assistant with an automatic "pending confirmation" message
  after booking and simple mock replies.
- 🧪 **Skin Profile** — choose your main concern, see recommendations, jump to booking.
- 🎁 **Promotions** — claim offers (claimed state is remembered).
- ❤️ **Favorites** — save clinics and treatments locally.
- ⭐ **Reviews** — leave a star rating + comment after a booking is completed.
- 🗺️ **Map** — stylized Phnom Penh clinic map with nearby clinic cards.

All bookings, favorites, claimed promos, the selected skin concern, chat
messages, and reviews are **persisted locally** and restored on restart.

## Tech stack

- **Flutter** (Material 3)
- **provider** — state management (`AppState` / `ChangeNotifier`)
- **go_router** — navigation
- **shared_preferences** — local persistence (JSON)
- **http** — API client for the NestJS mock backend (prepared, not yet wired in)
- **flutter_map**, **cached_network_image**, **intl**

## Backend API Preparation

The app currently uses **local / mock data** (assets + `SharedPreferences`) for
everything. A small API client layer is prepared so the app can be connected to
the **NestJS mock backend** later **without rewriting the screens**.

- The Flutter app is **not fully switched to backend data yet** — local/mock
  data is still the single source of truth, and all existing flows keep working.
- The API client lives in `lib/core/network/` (`api_config.dart`,
  `api_client.dart`, `api_result.dart`) and `lib/data/remote/backend_api_service.dart`.
- **Base URL** is set in one place, `ApiConfig.baseUrl`:
  - **Chrome / Flutter web:** `http://localhost:3000`
  - **Android emulator:** `http://10.0.2.2:3000`
    (use `ApiConfig.androidEmulatorBaseUrl`)
- `BackendApiService` exposes `getHealth`, `getClinics`, `getDoctors`,
  `getTreatments`, `getPromotions`, `getBookings`, `createBooking`,
  `updateBookingStatus`, `getChats`, and `sendChatMessage`. Each returns an
  `ApiResult` with either `data` or a readable `error`.
- To try it manually, start the backend (`cd backend && npm run start:dev`) and
  call `BackendApiService().debugPingHealth()`.

## Read-only backend catalog integration

The app can now load **read-only catalog data** — clinics, doctors, treatments,
and promotions — from the NestJS mock API, while everything else stays local.

- On startup, `AppState` calls the backend (`GET /clinics`, `/doctors`,
  `/treatments`, `/promotions`) through `CatalogRepository` and maps the JSON to
  the existing models.
- **Automatic fallback:** if the backend is offline, slow, errors, or returns an
  empty catalog, the app **silently keeps the local/mock data** — the app still
  opens and Home/Search/detail screens keep working. No error is shown to the
  user during the demo.
- The data source is tracked in `AppState.catalogSource` (`local` / `backend`)
  and shown as a small, non-intrusive label on the Home header
  ("Data source: Local demo data" or "Data source: Backend API").
- **Still local for now (MVP):** auth/login, chat, reviews, favorites, claimed
  promos, and skin-profile selection. Booking writes have a safe optional sync
  layer, described below.
- Base URL: Chrome uses `http://localhost:3000`; the Android emulator may use
  `http://10.0.2.2:3000` (see `ApiConfig`).

## Booking backend sync

Appointment booking now **optionally** syncs with the NestJS mock API while the
local flow stays the source of truth.

- **Create:** when a customer submits a booking, it is saved **locally first**
  (SharedPreferences) and the normal "request sent" success is shown. The app
  then sends it to `POST /bookings` in the background. On success the backend id
  is remembered (in memory) so later status updates can target the right record.
- **Status updates:** when staff (or the customer) confirm / cancel / complete /
  reschedule, the **local booking updates immediately** so the UI always works.
  The app then mirrors the change to `PATCH /bookings/:id/status` if that booking
  was synced. A failure here is ignored — the local update stands.
- **Fallback:** if the backend is offline, slow, or errors, nothing breaks —
  bookings live in local SharedPreferences exactly as before. No error dialog is
  shown to the user.
- **Startup pull:** after local SharedPreferences bookings are restored,
  `AppState.refreshBackendBookings()` runs in the background. Backend bookings
  are merged without deleting local bookings, and duplicate-looking records are
  skipped.
- Sync state is tracked in `AppState` (`isBookingSyncing`, `bookingSyncSource`
  = `local` / `backend`, `bookingSyncError`, `bookingSyncLabel`).
- **Still local for now:** auth/login, chat, reviews, favorites, claimed promos,
  and skin-profile selection. Staff login stays mock
  (`staff@jongsart.com` / `staff123`).

## Folder structure

```
lib/
├── main.dart                 # App entry (JongSartApp)
├── data/
│   ├── local_store.dart      # shared_preferences wrapper (JSON)
│   └── mock_repository.dart  # loads treatments from assets/mock
├── models/                   # Booking, Clinic, Doctor, Offer, Review, etc.
├── router/app_router.dart    # go_router routes
├── state/app_state.dart      # single source of truth (Provider)
├── theme/                    # colors, text styles, theme
├── widgets/                  # shared widgets (bottom nav, etc.)
└── features/
    ├── home/                 # Home screen
    ├── search/               # Search
    ├── detail/               # Clinic detail
    ├── treatment_detail/     # Treatment detail
    ├── doctor_profile/       # Doctor profile
    ├── booking/              # Book Consultation form
    ├── bookings/             # My Bookings + Booking Detail
    ├── staff/                # Clinic Staff (demo admin)
    ├── chat/ promo/ favorites/ reviews/ skin_profile/ map/
    └── app_flows/            # shared part-file hub for the flow screens
```

## How to run

```bash
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

To run on a phone or emulator, replace `chrome` with the device ID from:

```bash
flutter devices
```

## Screens

Home · Search · Treatment Detail · Clinic Detail · Doctor Profile · Book
Consultation · My Bookings · Booking Detail · Clinic Staff (Demo) · Favorites ·
Promotions · Chat · Map · Reviews · Skin Profile.

## Demo flow (for presentation)

1. On the splash screen tap **Get Started**, then log in as a **customer**
   (sign up first, or use the demo account `pengseyha0000@gmail.com` / `12345678`).
2. On **Home** → tap a skin concern or the **Book** quick action.
3. Fill the **Book Consultation** form and submit → see the "request sent" message.
4. Open **My Bookings** → the request is **Pending**, then **log out**.
5. Log in again as **staff** (`staff@jongsart.com` / `staff123`) → the
   **Clinic Staff Dashboard** shows the same pending request (shared local data).
6. **Confirm** the request, then **Mark Completed**, and **log out**.
7. Log back in as the customer → in **My Bookings / Booking Detail** the status is
   now **Confirmed/Completed**, and you can **Leave Review** from Booking Detail.
8. Close and reopen the app → bookings, favorites, and promos are still there.

## Current limitations

- Mock / local data only — no backend, server, or real authentication.
- All clinics, doctors, treatments, and reviews are fictional Cambodia-localized
  demo content (e.g. JongSart Skin Clinic, Sovanna Aesthetic Clinic; Dr. Sok
  Vicheka, Dr. Lim Rachana) — not real businesses or people.
- Detail screens (treatment/clinic/doctor) use representative sample content.
- The map is a stylized mock, not live map tiles.
- "Clinic Staff" uses a single mock staff login (`staff@jongsart.com` / `staff123`)
  and acts on the same local data as the customer on that device.

## Future improvements

- Real backend + accounts (customer and clinic staff roles).
- Live map with real clinic geolocation.
- Push / Telegram notifications for status changes.
- Real treatment, clinic, and doctor catalogs loaded from an API.
