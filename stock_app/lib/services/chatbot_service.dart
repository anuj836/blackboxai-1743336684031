import 'dart:async';

class ChatbotService {
  Future<String> getResponse(String userMessage) async {
    // Basic stock market related responses
    if (userMessage.toLowerCase().contains('hello') || 
        userMessage.toLowerCase().contains('hi')) {
      return 'Hello! How can I assist you with your stock market queries today?';
    } else if (userMessage.toLowerCase().contains('price') || 
               userMessage.toLowerCase().contains('stock price')) {
      return 'I can help you find stock prices. Please specify the company or ticker symbol.';
    } else if (userMessage.toLowerCase().contains('trend') || 
               userMessage.toLowerCase().contains('market trend')) {
      return 'Current market trends show [insert trend analysis here].';
    } else if (userMessage.toLowerCase().contains('buy') || 
               userMessage.toLowerCase().contains('sell')) {
      return 'For investment advice, please consult with a licensed financial advisor.';
    } else {
      return 'I specialize in stock market information. Could you clarify your question?';
    }
  }
}