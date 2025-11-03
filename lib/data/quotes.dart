/// List of motivational quotes to display when shake is detected
class Quotes {
  static final List<String> motivationalQuotes = [
    "Believe you can and you're halfway there!",
    "The only way to do great work is to love what you do.",
    "Don't watch the clock; do what it does. Keep going.",
    "Success is not final, failure is not fatal: it is the courage to continue that counts.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "You are never too old to set another goal or to dream a new dream.",
    "It does not matter how slowly you go as long as you do not stop.",
    "In the middle of difficulty lies opportunity.",
    "The only impossible journey is the one you never begin.",
    "Act as if what you do makes a difference. It does.",
    "You don't have to be great to start, but you have to start to be great.",
    "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
    "Keep going. Everything you need will come to you at the perfect time.",
    "Focus on progress, not perfection.",
    "Your limitation—it's only your imagination.",
    "Push yourself, because no one else is going to do it for you.",
    "Great things never come from comfort zones.",
    "Dream it. Wish it. Do it.",
    "Success doesn't just find you. You have to go out and get it.",
    "The harder you work for something, the greater you'll feel when you achieve it.",
    "Dream bigger. Do bigger.",
    "Don't stop when you're tired. Stop when you're done.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Do something today that your future self will thank you for.",
    "Little things make big things happen.",
    "It's going to be hard, but hard does not mean impossible.",
    "Don't wait for opportunity. Create it.",
    "The way to get started is to quit talking and begin doing.",
    "The only person you should try to be better than is the person you were yesterday.",
    "Start where you are. Use what you have. Do what you can.",
  ];

  /// Get a random quote from the list
  static String getRandomQuote() {
    final random =
        DateTime.now().millisecondsSinceEpoch % motivationalQuotes.length;
    return motivationalQuotes[random];
  }
}
