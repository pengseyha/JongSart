import { Injectable } from "@nestjs/common";
import { MockDataService } from "../mock/mock-data.service";

@Injectable()
export class TreatmentsService {
  constructor(private readonly mockData: MockDataService) {}

  findAll() {
    return this.mockData.getTreatments();
  }
}
