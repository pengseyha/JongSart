# JongSart Backend

This is a simple NestJS mock API for the JongSart MVP demo. It uses in-memory
data only, so data resets whenever the server restarts.

There is no PostgreSQL, Prisma, JWT, or Flutter integration yet.

## Run

```bash
cd backend
npm install
npm run start:dev
```

The API listens on `PORT` from the environment or defaults to `3000`.

## Build

```bash
cd backend
npm run build
```

## Demo Staff Account

```text
email: staff@jongsart.com
password: staff123
```

## Endpoints

```text
GET   /health

POST  /auth/register
POST  /auth/login

GET   /clinics
GET   /doctors
GET   /treatments
GET   /promotions

POST  /bookings
GET   /bookings
GET   /bookings/:id
PATCH /bookings/:id/status

GET   /chats
POST  /chats/messages

POST  /reviews
```

## Example curl Commands

Health:

```bash
curl http://localhost:3000/health
```

Register a customer:

```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Dara Sok","phone":"012345678","email":"dara@example.com","password":"secret123"}'
```

Customer login:

```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identifier":"dara@example.com","password":"secret123"}'
```

Staff login:

```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identifier":"staff@jongsart.com","password":"staff123"}'
```

List clinics, doctors, treatments, and promotions:

```bash
curl http://localhost:3000/clinics
curl http://localhost:3000/doctors
curl http://localhost:3000/treatments
curl http://localhost:3000/promotions
```

Create a booking request:

```bash
curl -X POST http://localhost:3000/bookings \
  -H "Content-Type: application/json" \
  -d '{"patientName":"Dara Sok","phone":"012345678","treatmentName":"Hydra Facial Care","clinicName":"JongSart Skin Clinic","doctorName":"Dr. Sok Vicheka","date":"Mon 30","time":"09:00 AM","note":"Sensitive skin"}'
```

Update booking status:

```bash
curl -X PATCH http://localhost:3000/bookings/booking_demo_1/status \
  -H "Content-Type: application/json" \
  -d '{"status":"Confirmed"}'
```

Shared clinic chat:

```bash
curl http://localhost:3000/chats

curl -X POST http://localhost:3000/chats/messages \
  -H "Content-Type: application/json" \
  -d '{"senderRole":"customer","senderName":"Dara Sok","message":"Hello, can you confirm my booking?"}'
```

Create a review:

```bash
curl -X POST http://localhost:3000/reviews \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Dara Sok","treatmentName":"Hydra Facial Care","rating":5,"comment":"Great consultation and friendly staff."}'
```

## Current Limitations

- In-memory data only.
- No production authentication or authorization.
- No database, Prisma, or migrations.
- Flutter frontend is not connected to this backend yet.
- Chat is one shared clinic thread for the demo.
