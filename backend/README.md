# JongSart Backend

This folder contains the starter structure for the future JongSart API.
JongSart is a skincare clinic booking system for Cambodia, and the backend will
eventually power customer accounts, clinic staff workflows, appointment
bookings, chat, reviews, and promotions.

This is only a clean starter scaffold. No production authentication, database
connection, or Flutter integration has been implemented yet.

## Planned Tech Stack

- NestJS
- PostgreSQL
- JWT authentication
- TypeScript

## Planned Modules

- `auth` - customer signup/login, staff login, JWT auth, roles
- `users` - customer and staff profiles
- `clinics` - clinic catalog and clinic details
- `doctors` - doctor profiles and clinic assignment
- `treatments` - treatment catalog, pricing, duration, categories
- `bookings` - appointment requests and staff status updates
- `chats` - customer/staff messages linked to bookings
- `reviews` - customer reviews after completed visits
- `promotions` - offers, bundles, and active promotions

## Planned API Endpoints

```text
POST  /auth/register
POST  /auth/login
GET   /clinics
GET   /doctors
GET   /treatments
POST  /bookings
GET   /bookings/my
GET   /staff/bookings
PATCH /bookings/:id/status
GET   /chats/:bookingId
POST  /chats/:bookingId/messages
POST  /reviews
GET   /promotions
```

The starter app uses a global `/api` prefix, so future routes will be exposed as
`/api/...` unless that setting changes.

## Install Later

```bash
cd backend
npm install
```

## Run Later

```bash
cd backend
npm run start:dev
```

The API will listen on `PORT` from `.env` or default to `3000`.

## Environment

Copy `.env.example` to `.env` when implementation begins:

```bash
cp .env.example .env
```

The current `.env.example` includes placeholders for future PostgreSQL and JWT
configuration only.

## Not Implemented Yet

- Real controllers and services
- Authentication logic
- Role guards
- PostgreSQL connection
- Database entities or migrations
- Flutter API integration
- Tests
