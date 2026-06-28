import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from "@nestjs/common";

export type UserRole = "customer" | "staff";

export interface CustomerAccount {
  id: string;
  fullName: string;
  phone: string;
  email?: string;
  password: string;
  createdAt: string;
}

export interface Clinic {
  id: string;
  name: string;
  specialty: string;
  address: string;
  distance: string;
  rating: number;
  tags: string[];
  isOpen: boolean;
}

export interface Doctor {
  id: string;
  name: string;
  specialty: string;
  clinicName: string;
  experienceYears: number;
  rating: number;
}

export interface Treatment {
  id: string;
  title: string;
  category: string;
  price: string;
  duration: string;
  description: string;
}

export interface Promotion {
  id: string;
  title: string;
  subtitle: string;
  price: string;
  badge: string;
}

export type BookingStatus =
  | "Pending Confirmation"
  | "Confirmed"
  | "Cancelled"
  | "Completed"
  | "Rescheduled";

export interface Booking {
  id: string;
  patientName: string;
  phone: string;
  treatmentName: string;
  clinicName: string;
  doctorName?: string;
  date: string;
  time: string;
  note?: string;
  status: BookingStatus;
  createdAt: string;
  updatedAt?: string;
}

export interface ChatMessage {
  id: string;
  senderRole: UserRole;
  senderName: string;
  message: string;
  createdAt: string;
}

export interface Review {
  id: string;
  customerName: string;
  treatmentName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

@Injectable()
export class MockDataService {
  private customers: CustomerAccount[] = [];

  private readonly clinics: Clinic[] = [
    {
      id: "clinic_lumina",
      name: "Lumina Skin Institute",
      specialty: "Laser dermatology and clinical facials",
      address: "Russian Federation Blvd, Phnom Penh",
      distance: "0.9 km",
      rating: 4.9,
      tags: ["Dermatology", "Laser", "Open"],
      isOpen: true,
    },
    {
      id: "clinic_emerald",
      name: "Emerald Medical Spa",
      specialty: "Hydration, anti-aging, and recovery care",
      address: "BKK1, Phnom Penh",
      distance: "2.7 km",
      rating: 4.8,
      tags: ["Cosmetic", "Hydrafacial"],
      isOpen: true,
    },
    {
      id: "clinic_north_peak",
      name: "North Peak Surgical",
      specialty: "Surgical dermatology and scar support",
      address: "Toul Kork, Phnom Penh",
      distance: "4.8 km",
      rating: 4.7,
      tags: ["Surgical", "Scar Care"],
      isOpen: false,
    },
  ];

  private readonly doctors: Doctor[] = [
    {
      id: "doctor_frances",
      name: "Dr. Frances",
      specialty: "Dermatologist",
      clinicName: "Lumina Skin Institute",
      experienceYears: 12,
      rating: 4.9,
    },
    {
      id: "doctor_sarah",
      name: "Dr. Sarah Chen",
      specialty: "Medical Laser",
      clinicName: "Lumina Skin Institute",
      experienceYears: 9,
      rating: 4.8,
    },
    {
      id: "doctor_lina",
      name: "Dr. Lina Sok",
      specialty: "Cosmetic Care",
      clinicName: "Emerald Medical Spa",
      experienceYears: 7,
      rating: 4.8,
    },
  ];

  private readonly treatments: Treatment[] = [
    {
      id: "treatment_hydra",
      title: "Bio-Restorative HydraFacial",
      category: "Facial",
      price: "$120",
      duration: "60 min",
      description:
        "Medical-grade hydration treatment for dry, congested combination skin.",
    },
    {
      id: "treatment_blue_light",
      title: "Blue Light Detox Therapy",
      category: "Acne Care",
      price: "$95",
      duration: "45 min",
      description:
        "Targeted blemish support for sensitive and breakout-prone skin.",
    },
    {
      id: "treatment_lactic_peel",
      title: "Lactic Silk Peel",
      category: "Peeling",
      price: "$115",
      duration: "50 min",
      description: "Gentle polish and glow support for uneven skin texture.",
    },
  ];

  private readonly promotions: Promotion[] = [
    {
      id: "offer_flash_facial",
      title: "Advanced Lactic Facial",
      subtitle: "Flash deal for sensitive glow care",
      price: "$85",
      badge: "40% Off",
    },
    {
      id: "offer_radiance_trio",
      title: "The Radiance Trio",
      subtitle: "3 clinical sessions with aftercare",
      price: "$120",
      badge: "Bundle",
    },
    {
      id: "offer_age_reverse",
      title: "Age-Reverse Cycle",
      subtitle: "Laser, recovery, and barrier repair",
      price: "$180",
      badge: "Premium",
    },
  ];

  private bookings: Booking[] = [
    {
      id: "booking_demo_1",
      patientName: "Dara Sok",
      phone: "012345678",
      treatmentName: "Bio-Restorative HydraFacial",
      clinicName: "Lumina Skin Institute",
      doctorName: "Dr. Frances",
      date: "Mon 30",
      time: "09:00 AM",
      note: "Sensitive skin, first consultation.",
      status: "Pending Confirmation",
      createdAt: "2026-06-28T02:15:00.000Z",
    },
  ];

  private chatMessages: ChatMessage[] = [
    {
      id: "chat_1",
      senderRole: "staff",
      senderName: "Clinic Staff",
      message: "Hello! Welcome to JongSart. How can our clinic help you today?",
      createdAt: "2026-06-28T02:00:00.000Z",
    },
  ];

  private reviews: Review[] = [
    {
      id: "review_1",
      customerName: "Elena Morn",
      treatmentName: "Chemical Peel",
      rating: 5,
      comment:
        "Professional, calming, and clear consultation. My skin feels hydrated.",
      createdAt: "2026-06-27T04:20:00.000Z",
    },
  ];

  registerCustomer(input: {
    fullName: string;
    phone: string;
    email?: string;
    password: string;
  }): Omit<CustomerAccount, "password"> {
    const normalizedEmail = input.email?.toLowerCase();
    const duplicate = this.customers.some(
      (customer) =>
        customer.phone === input.phone ||
        (normalizedEmail !== undefined && customer.email === normalizedEmail),
    );

    if (duplicate) {
      throw new ConflictException(
        "A customer with this phone or email already exists.",
      );
    }

    const customer: CustomerAccount = {
      id: this.createId("customer"),
      fullName: input.fullName,
      phone: input.phone,
      email: normalizedEmail,
      password: input.password,
      createdAt: new Date().toISOString(),
    };

    this.customers.push(customer);
    return this.withoutPassword(customer);
  }

  login(input: { identifier: string; password: string }) {
    const identifier = input.identifier.toLowerCase();
    if (identifier === "staff@jongsart.com" && input.password === "staff123") {
      return {
        token: "mock-token",
        userRole: "staff" as const,
        userName: "Clinic Staff",
        email: "staff@jongsart.com",
      };
    }

    const customer = this.customers.find(
      (account) =>
        (account.phone === input.identifier || account.email === identifier) &&
        account.password === input.password,
    );

    if (!customer) {
      throw new UnauthorizedException("Invalid login credentials.");
    }

    return {
      token: "mock-token",
      userRole: "customer" as const,
      userName: customer.fullName,
      phone: customer.phone,
      email: customer.email,
    };
  }

  getClinics(): Clinic[] {
    return [...this.clinics];
  }

  getDoctors(): Doctor[] {
    return [...this.doctors];
  }

  getTreatments(): Treatment[] {
    return [...this.treatments];
  }

  getPromotions(): Promotion[] {
    return [...this.promotions];
  }

  getBookings(): Booking[] {
    return [...this.bookings];
  }

  getBookingById(id: string): Booking {
    const booking = this.bookings.find((item) => item.id === id);
    if (!booking) {
      throw new NotFoundException("Booking not found.");
    }
    return booking;
  }

  createBooking(input: Omit<Booking, "id" | "status" | "createdAt">): Booking {
    const booking: Booking = {
      id: this.createId("booking"),
      ...input,
      status: "Pending Confirmation",
      createdAt: new Date().toISOString(),
    };
    this.bookings.unshift(booking);
    this.addChatMessage({
      senderRole: "staff",
      senderName: "Clinic Staff",
      message:
        "Thank you. Your appointment request is pending confirmation. Our clinic staff will contact you soon.",
    });
    return booking;
  }

  updateBookingStatus(id: string, status: BookingStatus): Booking {
    if (!this.isBookingStatus(status)) {
      throw new BadRequestException("Invalid booking status.");
    }

    const index = this.bookings.findIndex((booking) => booking.id === id);
    if (index === -1) {
      throw new NotFoundException("Booking not found.");
    }

    this.bookings[index] = {
      ...this.bookings[index],
      status,
      updatedAt: new Date().toISOString(),
    };
    return this.bookings[index];
  }

  getChatMessages(): ChatMessage[] {
    return [...this.chatMessages];
  }

  addChatMessage(input: {
    senderRole: UserRole;
    senderName: string;
    message: string;
    createdAt?: string;
  }): ChatMessage {
    if (input.senderRole !== "customer" && input.senderRole !== "staff") {
      throw new BadRequestException("senderRole must be customer or staff.");
    }

    const chatMessage: ChatMessage = {
      id: this.createId("chat"),
      senderRole: input.senderRole,
      senderName: input.senderName,
      message: input.message,
      createdAt: input.createdAt ?? new Date().toISOString(),
    };
    this.chatMessages.push(chatMessage);
    return chatMessage;
  }

  createReview(input: Omit<Review, "id" | "createdAt">): Review {
    if (input.rating < 1 || input.rating > 5) {
      throw new BadRequestException("rating must be between 1 and 5.");
    }

    const review: Review = {
      id: this.createId("review"),
      ...input,
      createdAt: new Date().toISOString(),
    };
    this.reviews.unshift(review);
    return review;
  }

  private withoutPassword(
    customer: CustomerAccount,
  ): Omit<CustomerAccount, "password"> {
    const { password: _password, ...safeCustomer } = customer;
    return safeCustomer;
  }

  private isBookingStatus(status: string): status is BookingStatus {
    return [
      "Pending Confirmation",
      "Confirmed",
      "Cancelled",
      "Completed",
      "Rescheduled",
    ].includes(status);
  }

  private createId(prefix: string): string {
    return `${prefix}_${Date.now()}_${Math.random().toString(16).slice(2, 8)}`;
  }
}
