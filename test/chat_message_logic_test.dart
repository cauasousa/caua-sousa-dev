import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio/feature/presentation/widgets/chat/chat_message.dart';

void main() {
  group('AiChatBubble response handling', () {
    test(
        'returns the contact message when the backend marks the response as duplicate',
        () {
      final response = AiChatBubble.resolveResponseMessage({
        'response': 'This is a duplicate answer',
        'is_duplicate': true,
      });

      expect(response, 'Contact Cauã for more information.');
    });

    test('returns the backend response when it is not a duplicate', () {
      final response = AiChatBubble.resolveResponseMessage({
        'response': 'This is the real answer',
        'is_duplicate': false,
      });

      expect(response, 'This is the real answer');
    });
  });
}
