/// Represents a Mood entry
class Mood {
  Mood(this.level, this.when);

  static const moodsList = [
    "Horrible",
    "Really bad",
    "Pretty bad",
    "Bad",
    "Not Great",
    "Neutral",
    "Okay",
    "Decent",
    "Good",
    "Great",
    "Fantastic",
  ];

  final int level;
  final DateTime when;
}
