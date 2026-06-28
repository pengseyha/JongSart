import 'package:flutter/foundation.dart';

import '../../models/chat_message.dart';
import 'backend_api_service.dart';

/// Best-effort bridge between the local shared chat thread and the NestJS API.
///
/// Methods never throw to UI callers. If the backend is unavailable or returns
/// unexpected data, the local SharedPreferences thread continues to work.
class ChatRepository {
  ChatRepository({BackendApiService? api}) : _api = api ?? BackendApiService();

  final BackendApiService _api;

  /// GET /chats — returns backend messages, or an empty list on failure.
  Future<List<ChatMessage>> getBackendChats() async {
    final result = await _api.getChats();
    if (result.isFailure) {
      _log('getBackendChats failed: ${result.error}');
      return const <ChatMessage>[];
    }

    final data = result.data ?? const [];
    try {
      return data
          .whereType<Map>()
          .map(
            (item) => _messageFromBackendJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (e) {
      _log('getBackendChats mapping failed: $e');
      return const <ChatMessage>[];
    }
  }

  /// POST /chats/messages — sends a locally-created message to the backend.
  /// Returns the backend message or null on failure.
  Future<ChatMessage?> sendBackendChatMessage(ChatMessage message) async {
    final result = await _api.sendChatMessage(_toBackendPayload(message));
    if (result.isFailure || result.data == null) {
      _log('sendBackendChatMessage failed: ${result.error}');
      return null;
    }

    try {
      return _messageFromBackendJson(result.data!);
    } catch (e) {
      _log('sendBackendChatMessage mapping failed: $e');
      return null;
    }
  }

  Map<String, dynamic> _toBackendPayload(ChatMessage message) {
    final isCustomer = message.isMe;
    return {
      'senderRole': isCustomer ? 'customer' : 'staff',
      'senderName': isCustomer ? 'Customer' : 'Clinic Staff',
      'message': message.text,
      'createdAt': message.sentAt.toIso8601String(),
    };
  }

  ChatMessage _messageFromBackendJson(Map<String, dynamic> json) {
    final senderRole = (json['senderRole'] ?? '').toString().toLowerCase();
    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      text: (json['message'] ?? json['text'] ?? '').toString(),
      isMe: senderRole == 'customer',
      sentAt: DateTime.tryParse(
            (json['createdAt'] ?? json['sentAt'] ?? '').toString(),
          ) ??
          DateTime.now(),
    );
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[ChatRepository] $message');
  }
}
