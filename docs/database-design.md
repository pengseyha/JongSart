# Database Design

JongSart is planned to use PostgreSQL. No database connection or migrations are
implemented yet.

## Planned Tables

### users

- `id`
- `name`
- `phone`
- `email`
- `password_hash`
- `role` (`customer`, `staff`, `admin`)
- `created_at`
- `updated_at`

### clinics

- `id`
- `name`
- `specialty`
- `address`
- `phone`
- `is_open`
- `rating`
- `created_at`
- `updated_at`

### doctors

- `id`
- `clinic_id`
- `name`
- `specialty`
- `experience_years`
- `rating`
- `bio`
- `created_at`
- `updated_at`

### treatments

- `id`
- `title`
- `category`
- `description`
- `price`
- `duration_minutes`
- `created_at`
- `updated_at`

### bookings

- `id`
- `customer_id`
- `clinic_id`
- `doctor_id`
- `treatment_id`
- `patient_name`
- `phone`
- `concern`
- `preferred_date`
- `preferred_time`
- `status`
- `note`
- `created_at`
- `updated_at`

### chat_messages

- `id`
- `booking_id`
- `sender_id`
- `message`
- `created_at`

### reviews

- `id`
- `booking_id`
- `customer_id`
- `clinic_id`
- `treatment_id`
- `rating`
- `comment`
- `created_at`

### promotions

- `id`
- `title`
- `description`
- `badge`
- `price`
- `starts_at`
- `ends_at`
- `is_active`
- `created_at`
- `updated_at`

## Relationships

- A clinic has many doctors.
- A clinic has many bookings.
- A treatment has many bookings.
- A customer has many bookings.
- A booking can have many chat messages.
- A completed booking can have one review.

## Current Scope

This is only a planning document. Entities, migrations, and database connection
will be added later.
