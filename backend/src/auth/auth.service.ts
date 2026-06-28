import { BadRequestException, Injectable } from "@nestjs/common";
import { optionalText, requireText } from "../common/validation";
import { MockDataService } from "../mock/mock-data.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";

@Injectable()
export class AuthService {
  constructor(private readonly mockData: MockDataService) {}

  register(body: RegisterDto) {
    const fullName = requireText(body, "fullName");
    const phone = requireText(body, "phone");
    const email = optionalText(body, "email");
    const password = requireText(body, "password");

    if (password.length < 6) {
      throw new BadRequestException("password must be at least 6 characters.");
    }

    const user = this.mockData.registerCustomer({
      fullName,
      phone,
      email,
      password,
    });

    return {
      message: "Customer registered successfully.",
      token: "mock-token",
      userRole: "customer",
      userName: user.fullName,
      phone: user.phone,
      email: user.email,
    };
  }

  login(body: LoginDto) {
    const identifier =
      optionalText(body, "identifier") ??
      optionalText(body, "email") ??
      optionalText(body, "phone");

    if (identifier === undefined) {
      throw new BadRequestException("identifier, email, or phone is required.");
    }

    const password = requireText(body, "password");
    return this.mockData.login({ identifier, password });
  }
}
