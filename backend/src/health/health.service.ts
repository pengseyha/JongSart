import { Injectable } from "@nestjs/common";

@Injectable()
export class HealthService {
  getHealth() {
    return {
      status: "ok",
      service: "JongSart Mock API",
      timestamp: new Date().toISOString(),
    };
  }
}
