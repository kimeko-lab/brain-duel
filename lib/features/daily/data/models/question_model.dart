class QuestionModel {
  final String id;
  final String category;   // e.g. 'science', 'geography'
  final String rarity;     // 'common' | 'rare'
  final String text;
  final List<String> options;  // exactly 4 items for MC4
  final int correctIndex;      // 0–3

  const QuestionModel({
    required this.id,
    required this.category,
    required this.rarity,
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}
