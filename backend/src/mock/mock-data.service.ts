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
      name: "JongSart Skin Clinic",
      specialty: "Dermatology consultation and clinical facials",
      address: "BKK1, Phnom Penh",
      distance: "0.9 km",
      rating: 4.9,
      tags: ["Dermatology", "Facial", "Open"],
      isOpen: true,
    },
    {
      id: "clinic_emerald",
      name: "Sovanna Aesthetic Clinic",
      specialty: "Facial care and skin health consultation",
      address: "Toul Kork, Phnom Penh",
      distance: "2.7 km",
      rating: 4.8,
      tags: ["Acne Care", "Hydra Facial"],
      isOpen: true,
    },
    {
      id: "clinic_north_peak",
      name: "Mekong Dermatology Center",
      specialty: "Pigmentation care and scar care consultation",
      address: "Sen Sok, Phnom Penh",
      distance: "4.8 km",
      rating: 4.7,
      tags: ["Pigmentation", "Scar Care"],
      isOpen: false,
    },
    {
      id: "clinic_tonle",
      name: "Tonle Skin & Beauty Clinic",
      specialty: "Facial treatments and brightening care",
      address: "Street 271, Phnom Penh",
      distance: "3.4 km",
      rating: 4.7,
      tags: ["Facial", "Brightening", "Open"],
      isOpen: true,
    },
    {
      id: "clinic_ppderma",
      name: "Phnom Penh Derma Care",
      specialty: "Skin health consultation and laser care",
      address: "Monivong Blvd, Phnom Penh",
      distance: "5.2 km",
      rating: 4.6,
      tags: ["Dermatology", "Laser"],
      isOpen: true,
    },
  ];

  private readonly doctors: Doctor[] = [
    {
      id: "doctor_frances",
      name: "Dr. Sok Vicheka",
      specialty: "Dermatology Consultation",
      clinicName: "JongSart Skin Clinic",
      experienceYears: 12,
      rating: 4.9,
    },
    {
      id: "doctor_sarah",
      name: "Dr. Lim Rachana",
      specialty: "Laser & Pigmentation Care",
      clinicName: "JongSart Skin Clinic",
      experienceYears: 9,
      rating: 4.8,
    },
    {
      id: "doctor_lina",
      name: "Dr. Chan Sopheak",
      specialty: "Acne & Sensitive Skin Care",
      clinicName: "Sovanna Aesthetic Clinic",
      experienceYears: 7,
      rating: 4.8,
    },
    {
      id: "doctor_sreyneang",
      name: "Dr. Kim Sreyneang",
      specialty: "Aesthetic Dermatology",
      clinicName: "Tonle Skin & Beauty Clinic",
      experienceYears: 8,
      rating: 4.8,
    },
    {
      id: "doctor_dara",
      name: "Dr. Heng Dara",
      specialty: "Skin Health Consultation",
      clinicName: "Phnom Penh Derma Care",
      experienceYears: 10,
      rating: 4.7,
    },
  ];

  private readonly treatments: Treatment[] = [
    {
      id: "treatment_hydra",
      title: "Hydra Facial Care",
      category: "Facial",
      price: "$45",
      duration: "45 min",
      description:
        "A hydrating facial care option that may help dry or combination skin. Clinic staff will confirm suitability first.",
    },
    {
      id: "treatment_blue_light",
      title: "Acne Consultation",
      category: "Consultation",
      price: "$15",
      duration: "30 min",
      description:
        "A short consultation for acne and breakout-prone skin. Clinic staff will recommend a suitable care option.",
    },
    {
      id: "treatment_lactic_peel",
      title: "Brightening Facial Care",
      category: "Facial",
      price: "$40",
      duration: "45 min",
      description:
        "A gentle facial care option that may help with uneven or dull skin tone.",
    },
    {
      id: "treatment_deep_clean",
      title: "Deep Cleansing Facial",
      category: "Facial",
      price: "$35",
      duration: "60 min",
      description:
        "Designed for skin that feels oily or congested. Clinic staff will check the skin condition before recommending care.",
    },
    {
      id: "treatment_sensitive",
      title: "Sensitive Skin Consultation",
      category: "Consultation",
      price: "$18",
      duration: "30 min",
      description:
        "A consultation for sensitive or easily irritated skin to help find a suitable care option.",
    },
    {
      id: "treatment_pigmentation",
      title: "Pigmentation Care Consultation",
      category: "Laser & Pigmentation",
      price: "$90",
      duration: "50 min",
      description:
        "A consultation for dark spots and uneven tone. Clinic staff will confirm suitability before any care.",
    },
    {
      id: "treatment_scar",
      title: "Scar Care Consultation",
      category: "Consultation",
      price: "$25",
      duration: "40 min",
      description:
        "A consultation that may help customers understand care options for acne scars or marks.",
    },
    {
      id: "treatment_antiaging",
      title: "Anti-Aging Facial",
      category: "Facial",
      price: "$55",
      duration: "60 min",
      description:
        "A facial care option that may help with fine lines and skin texture. Clinic staff will confirm suitability.",
    },
    {
      id: "treatment_pore",
      title: "Pore Cleansing Treatment",
      category: "Facial",
      price: "$30",
      duration: "45 min",
      description:
        "A pore cleansing care option for skin affected by daily pollution and congestion.",
    },
    {
      id: "treatment_barrier",
      title: "Skin Barrier Recovery Care",
      category: "Recovery Care",
      price: "$40",
      duration: "50 min",
      description:
        "A recovery care option that may help support a dry or sensitive skin barrier.",
    },
  ];

  private readonly promotions: Promotion[] = [
    {
      id: "offer_flash_facial",
      title: "First Visit Consultation Discount",
      subtitle:
        "For new customers booking through JongSart. Clinic staff will confirm the available time before the visit.",
      price: "$12",
      badge: "New",
    },
    {
      id: "offer_radiance_trio",
      title: "Weekend Facial Offer",
      subtitle: "Deep cleansing facial care on weekends",
      price: "$30",
      badge: "Weekend",
    },
    {
      id: "offer_age_reverse",
      title: "Student Skin Care Package",
      subtitle: "Consultation and basic facial for students",
      price: "$20",
      badge: "Student",
    },
    {
      id: "offer_acne_promo",
      title: "Acne Care Consultation Promo",
      subtitle: "Acne consultation with a recommended care option",
      price: "$15",
      badge: "Promo",
    },
    {
      id: "offer_hydra_month",
      title: "Hydra Facial Month-End Offer",
      subtitle: "Hydra facial care at a special month-end rate",
      price: "$40",
      badge: "Limited",
    },
  ];

  private bookings: Booking[] = [
    {
      id: "booking_demo_1",
      patientName: "Dara Sok",
      phone: "012345678",
      treatmentName: "Hydra Facial Care",
      clinicName: "JongSart Skin Clinic",
      doctorName: "Dr. Sok Vicheka",
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
      message:
        "Thank you for contacting JongSart. Please share your preferred date and phone number, our clinic staff will confirm the appointment.",
      createdAt: "2026-06-28T02:00:00.000Z",
    },
  ];

  private reviews: Review[] = [
    {
      id: "review_1",
      customerName: "Sreyneang",
      treatmentName: "Deep Cleansing Facial",
      rating: 5,
      comment:
        "The staff explained the facial process clearly and the clinic was clean. Booking through the app was simple.",
      createdAt: "2026-06-27T04:20:00.000Z",
    },
    {
      id: "review_2",
      customerName: "Dara",
      treatmentName: "Acne Consultation",
      rating: 4,
      comment:
        "I liked that the appointment was pending first, then staff contacted me to confirm the time.",
      createdAt: "2026-06-26T09:10:00.000Z",
    },
    {
      id: "review_3",
      customerName: "Pisey",
      treatmentName: "Skin Health Consultation",
      rating: 5,
      comment:
        "The consultation helped me understand which treatment was suitable for my skin concern.",
      createdAt: "2026-06-25T07:45:00.000Z",
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
        "Your appointment request has been sent. Clinic staff will contact you to confirm the schedule.",
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
