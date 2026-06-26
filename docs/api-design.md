# API Design

JongSart will use a NestJS backend API for customer booking and clinic staff
management. The Flutter app is not connected to this API yet.

## Base Path

Planned base path:

```text
/api
```

## Planned Endpoints

| Method | Path | Purpose |
| --- | --- | --- |
| POST | `/auth/register` | Register a customer account |
| POST | `/auth/login` | Login customer or staff account |
| GET | `/clinics` | List clinics |
| GET | `/doctors` | List doctors |
| GET | `/treatments` | List treatments |
| POST | `/bookings` | Customer submits appointment request |
| GET | `/bookings/my` | Customer views their bookings |
| GET | `/staff/bookings` | Staff views clinic booking requests |
| PATCH | `/bookings/:id/status` | Staff confirms, reschedules, completes, or cancels booking |
| GET | `/chats/:bookingId` | Get chat messages for a booking |
| POST | `/chats/:bookingId/messages` | Send chat message for a booking |
| POST | `/reviews` | Customer submits review after completed booking |
| GET | `/promotions` | List active promotions |

## Booking Status Flow

```text
pending -> confirmed -> completed
pending -> rescheduled -> confirmed
pending -> cancelled
confirmed -> cancelled
```

## Authentication Plan

- Customers can register and login.
- Staff can login.
- JWT will protect customer and staff-only routes.
- Staff-only endpoints should require a staff role.

## Current Scope

This is planning only. No backend endpoints are implemented yet, and the Flutter
frontend still uses local/mock data.
