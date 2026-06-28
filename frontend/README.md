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
- **flutter_map**, **cached_network_image**, **intl**

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

1. Open **Home** → tap a skin concern or **Book** quick action.
2. Fill the **Book Consultation** form and submit → see the "request sent" message.
3. Open **My Bookings** → the request is **Pending**.
4. From Home quick actions open **Clinic Staff (Demo)** → **Confirm** the request.
5. Back in **My Bookings / Booking Detail** → status is now **Confirmed**.
6. In Clinic Staff, **Mark Completed** → then **Leave Review** from Booking Detail.
7. Close and reopen the app → bookings, favorites, and promos are still there.

## Current limitations

- Mock / local data only — no backend, server, or real authentication.
- All clinics, doctors, treatments, and reviews are fictional Cambodia-localized
  demo content (e.g. JongSart Skin Clinic, Sovanna Aesthetic Clinic; Dr. Sok
  Vicheka, Dr. Lim Rachana) — not real businesses or people.
- Detail screens (treatment/clinic/doctor) use representative sample content.
- The map is a stylized mock, not live map tiles.
- "Clinic Staff" is a demo admin view on the same device (no separate login).

## Future improvements

- Real backend + accounts (customer and clinic staff roles).
- Live map with real clinic geolocation.
- Push / Telegram notifications for status changes.
- Real treatment, clinic, and doctor catalogs loaded from an API.
