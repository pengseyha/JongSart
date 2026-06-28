import { Controller, Get } from "@nestjs/common";
import { TreatmentsService } from "./treatments.service";

@Controller("treatments")
export class TreatmentsController {
  constructor(private readonly treatmentsService: TreatmentsService) {}

  @Get()
  findAll() {
    return this.treatmentsService.findAll();
  }
}
