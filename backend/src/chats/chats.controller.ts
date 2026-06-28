import { Body, Controller, Get, Post } from "@nestjs/common";
import { ChatsService } from "./chats.service";
import { CreateChatMessageDto } from "./dto/create-chat-message.dto";

@Controller("chats")
export class ChatsController {
  constructor(private readonly chatsService: ChatsService) {}

  @Get()
  findAll() {
    return this.chatsService.findAll();
  }

  @Post("messages")
  createMessage(@Body() body: CreateChatMessageDto) {
    return this.chatsService.createMessage(body);
  }
}
