import { Module } from "@nestjs/common";
import { AuthModule } from "./auth/auth.module";
import { BookingsModule } from "./bookings/bookings.module";
import { ChatsModule } from "./chats/chats.module";
import { ClinicsModule } from "./clinics/clinics.module";
import { DoctorsModule } from "./doctors/doctors.module";
import { HealthModule } from "./health/health.module";
import { MockDataModule } from "./mock/mock-data.module";
import { PromotionsModule } from "./promotions/promotions.module";
import { ReviewsModule } from "./reviews/reviews.module";
import { TreatmentsModule } from "./treatments/treatments.module";

@Module({
  imports: [
    MockDataModule,
    HealthModule,
    AuthModule,
    ClinicsModule,
    DoctorsModule,
    TreatmentsModule,
    BookingsModule,
    ChatsModule,
    ReviewsModule,
    PromotionsModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
