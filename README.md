# JongSart

JongSart is a skincare clinic booking system for Cambodia. It helps customers
discover clinics, treatments, and doctors, then submit appointment requests for
clinic staff to review and confirm.

## Project Structure

```text
JongSart/
├── frontend/   # Flutter mobile app
├── backend/    # Future API service
├── docs/       # Planning and design documents
├── README.md   # Full-stack project overview
└── .gitignore
```

## Frontend

The `frontend/` folder contains the existing Flutter mobile app. The current
version uses local/mock data and `SharedPreferences` for persistence. There is
no production backend or authentication yet.

To run the mobile app:

```bash
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Backend

The `backend/` folder is reserved for the future API implementation. No backend
code has been added yet.

## Docs

The `docs/` folder contains planning documents for app flow, API design, and
database design.
