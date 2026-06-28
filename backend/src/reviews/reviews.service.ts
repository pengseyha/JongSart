import { BadRequestException, Injectable } from "@nestjs/common";
import { requireText } from "../common/validation";
import { MockDataService } from "../mock/mock-data.service";
import { CreateReviewDto } from "./dto/create-review.dto";

@Injectable()
export class ReviewsService {
  constructor(private readonly mockData: MockDataService) {}

  create(body: CreateReviewDto) {
    const ratingValue = body.rating;
    const rating =
      typeof ratingValue === "number"
        ? ratingValue
        : Number.parseFloat(String(ratingValue));

    if (!Number.isFinite(rating)) {
      throw new BadRequestException("rating is required and must be a number.");
    }

    return this.mockData.createReview({
      customerName: requireText(body, "customerName"),
      treatmentName: requireText(body, "treatmentName"),
      rating,
      comment: requireText(body, "comment"),
    });
  }
}
