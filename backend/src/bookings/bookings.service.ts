import { Injectable } from "@nestjs/common";
import { optionalText, requireText } from "../common/validation";
import { BookingStatus, MockDataService } from "../mock/mock-data.service";
import { CreateBookingDto } from "./dto/create-booking.dto";
import { UpdateBookingStatusDto } from "./dto/update-booking-status.dto";

@Injectable()
export class BookingsService {
  constructor(private readonly mockData: MockDataService) {}

  create(body: CreateBookingDto) {
    return this.mockData.createBooking({
      patientName: requireText(body, "patientName"),
      phone: requireText(body, "phone"),
      treatmentName: requireText(body, "treatmentName"),
      clinicName: requireText(body, "clinicName"),
      doctorName: optionalText(body, "doctorName"),
      date: requireText(body, "date"),
      time: requireText(body, "time"),
      note: optionalText(body, "note"),
    });
  }

  findAll() {
    return this.mockData.getBookings();
  }

  findOne(id: string) {
    return this.mockData.getBookingById(id);
  }

  updateStatus(id: string, body: UpdateBookingStatusDto) {
    const status = requireText(body, "status") as BookingStatus;
    return this.mockData.updateBookingStatus(id, status);
  }
}
