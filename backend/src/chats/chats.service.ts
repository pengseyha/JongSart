import { Injectable } from "@nestjs/common";
import { optionalText, requireText } from "../common/validation";
import { MockDataService, UserRole } from "../mock/mock-data.service";
import { CreateChatMessageDto } from "./dto/create-chat-message.dto";

@Injectable()
export class ChatsService {
  constructor(private readonly mockData: MockDataService) {}

  findAll() {
    return this.mockData.getChatMessages();
  }

  createMessage(body: CreateChatMessageDto) {
    return this.mockData.addChatMessage({
      senderRole: requireText(body, "senderRole") as UserRole,
      senderName: requireText(body, "senderName"),
      message: requireText(body, "message"),
      createdAt: optionalText(body, "createdAt"),
    });
  }
}
