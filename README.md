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
version uses local/mock data and `SharedPreferences` for persistence.

To run the mobile app:

```bash
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

You can also run on an Android emulator or connected phone:

```bash
cd frontend
flutter run
```

## Backend

The `backend/` folder contains a NestJS starter service. The Flutter app is not
connected to it yet.

To verify the backend build:

```bash
cd backend
npm run build
```

## Demo Accounts

Staff login:

```text
username: staff@jongsart.com
password: staff123
```

Customer accounts are created locally inside the app from the Sign Up screen.
Use any demo name, phone number, optional email, and password with at least 6
characters.

## MVP Demo Flow

Customer:

1. Open the app and choose `Customer`.
2. Sign up or log in.
3. Confirm the Home screen shows the customer name.
4. Tap `Book Consultation`, or choose a treatment/clinic.
5. Submit the booking request.
6. Confirm the booking is created as `Pending Confirmation`.
7. Open `My Bookings`, then `View Detail`.
8. Tap `Chat Clinic` and send a message.

Staff:

1. Log out from the customer account.
2. Choose `Staff Login`.
3. Log in with the staff demo account above.
4. Open the Clinic Staff Dashboard.
5. Use the `Pending`, `Confirmed`, `Completed`, and `Cancelled` tabs.
6. Confirm the pending booking.
7. Open `Reply Chat` and reply to the customer.
8. Mark the confirmed booking completed.

Customer again:

1. Log in again if needed.
2. Open `My Bookings`.
3. Confirm the booking status is now `Confirmed` or `Completed`.
4. If completed, open the booking detail and leave a review.

## Current Limitations

- Data is local/mock only and stored with `SharedPreferences`.
- Customer auth and staff auth are demo-only, not secure production auth.
- The frontend is not connected to the NestJS backend yet.
- Chat uses one shared clinic thread instead of per-booking conversations.

## Docs

The `docs/` folder contains planning documents for app flow, API design, and
database design.
