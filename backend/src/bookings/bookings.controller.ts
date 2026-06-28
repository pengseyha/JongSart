import { Body, Controller, Get, Param, Patch, Post } from "@nestjs/common";
import { BookingsService } from "./bookings.service";
import { CreateBookingDto } from "./dto/create-booking.dto";
import { UpdateBookingStatusDto } from "./dto/update-booking-status.dto";

@Controller("bookings")
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  create(@Body() body: CreateBookingDto) {
    return this.bookingsService.create(body);
  }

  @Get()
  findAll() {
    return this.bookingsService.findAll();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.bookingsService.findOne(id);
  }

  @Patch(":id/status")
  updateStatus(@Param("id") id: string, @Body() body: UpdateBookingStatusDto) {
    return this.bookingsService.updateStatus(id, body);
  }
}
