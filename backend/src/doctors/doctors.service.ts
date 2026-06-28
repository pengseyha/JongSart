import { Injectable } from "@nestjs/common";
import { MockDataService } from "../mock/mock-data.service";

@Injectable()
export class DoctorsService {
  constructor(private readonly mockData: MockDataService) {}

  findAll() {
    return this.mockData.getDoctors();
  }
}
