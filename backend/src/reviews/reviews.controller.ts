import { Body, Controller, Post } from "@nestjs/common";
import { CreateReviewDto } from "./dto/create-review.dto";
import { ReviewsService } from "./reviews.service";

@Controller("reviews")
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Post()
  create(@Body() body: CreateReviewDto) {
    return this.reviewsService.create(body);
  }
}
