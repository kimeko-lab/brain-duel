import 'package:brain_duel/features/daily/data/models/question_model.dart';
import 'package:brain_duel/features/daily/domain/repositories/question_repository.dart';

class MockQuestionService implements QuestionRepository {
  @override
  Future<List<QuestionModel>> getQuestionsForCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _questions[category] ?? [];
  }

  @override
  Future<List<QuestionModel>> getAllQuestions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final all = _questions.values.expand((q) => q).toList();
    all.shuffle();
    return all;
  }

  static const _questions = <String, List<QuestionModel>>{
    'science': [
      QuestionModel(
        id: 'sci_001',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'What is the chemical symbol for gold?',
        options: ['Go', 'Gd', 'Au', 'Ag'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'sci_002',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'How many bones are in the adult human body?',
        options: ['186', '206', '216', '226'],
        correctIndex: 1,
      ),
      QuestionModel(
        id: 'sci_003',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'What planet is known as the Red Planet?',
        options: ['Venus', 'Jupiter', 'Saturn', 'Mars'],
        correctIndex: 3,
      ),
      QuestionModel(
        id: 'sci_004',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'What gas do plants absorb from the atmosphere during photosynthesis?',
        options: ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'sci_005',
        category: 'science',
        rarity: QuestionRarity.common,
        text: 'What is the speed of light in a vacuum (approximately)?',
        options: ['300,000 km/s', '150,000 km/s', '450,000 km/s', '600,000 km/s'],
        correctIndex: 0,
      ),
    ],
    'geography': [
      QuestionModel(
        id: 'geo_001',
        category: 'geography',
        rarity: QuestionRarity.common,
        text: 'What is the largest country in the world by area?',
        options: ['Canada', 'China', 'United States', 'Russia'],
        correctIndex: 3,
      ),
      QuestionModel(
        id: 'geo_002',
        category: 'geography',
        rarity: QuestionRarity.common,
        text: 'Which river is the longest in the world?',
        options: ['Amazon', 'Yangtze', 'Nile', 'Mississippi'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'geo_003',
        category: 'geography',
        rarity: QuestionRarity.common,
        text: 'What is the capital city of Australia?',
        options: ['Sydney', 'Melbourne', 'Brisbane', 'Canberra'],
        correctIndex: 3,
      ),
      QuestionModel(
        id: 'geo_004',
        category: 'geography',
        rarity: QuestionRarity.common,
        text: 'On which continent is the Sahara Desert located?',
        options: ['Asia', 'South America', 'Africa', 'Australia'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'geo_005',
        category: 'geography',
        rarity: QuestionRarity.common,
        text: 'Which ocean is the largest by surface area?',
        options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
        correctIndex: 3,
      ),
    ],
    'history': [
      QuestionModel(
        id: 'his_001',
        category: 'history',
        rarity: QuestionRarity.common,
        text: 'In which year did World War II end?',
        options: ['1943', '1944', '1945', '1946'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'his_002',
        category: 'history',
        rarity: QuestionRarity.common,
        text: 'Who was the first President of the United States?',
        options: ['John Adams', 'Thomas Jefferson', 'Benjamin Franklin', 'George Washington'],
        correctIndex: 3,
      ),
      QuestionModel(
        id: 'his_003',
        category: 'history',
        rarity: QuestionRarity.common,
        text: 'The ancient city of Rome was traditionally said to be built on how many hills?',
        options: ['Five', 'Six', 'Seven', 'Eight'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'his_004',
        category: 'history',
        rarity: QuestionRarity.common,
        text: 'Which empire was ruled by Julius Caesar?',
        options: ['Greek Empire', 'Ottoman Empire', 'Roman Empire', 'Persian Empire'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'his_005',
        category: 'history',
        rarity: QuestionRarity.common,
        text: 'In which year did the Berlin Wall fall?',
        options: ['1987', '1988', '1989', '1990'],
        correctIndex: 2,
      ),
    ],
    'sport': [
      QuestionModel(
        id: 'spt_001',
        category: 'sport',
        rarity: QuestionRarity.common,
        text: 'How many players are on a standard soccer (football) team on the field?',
        options: ['9', '10', '11', '12'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'spt_002',
        category: 'sport',
        rarity: QuestionRarity.common,
        text: 'In which sport would you perform a "slam dunk"?',
        options: ['Volleyball', 'Basketball', 'Tennis', 'Baseball'],
        correctIndex: 1,
      ),
      QuestionModel(
        id: 'spt_003',
        category: 'sport',
        rarity: QuestionRarity.common,
        text: 'How many gold rings are on the Olympic flag?',
        options: ['3', '4', '5', '6'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'spt_004',
        category: 'sport',
        rarity: QuestionRarity.common,
        text: 'In tennis, what is the term for a score of zero?',
        options: ['Nil', 'Zero', 'Love', 'Nought'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'spt_005',
        category: 'sport',
        rarity: QuestionRarity.common,
        text: 'How many holes are played in a standard round of golf?',
        options: ['9', '12', '18', '24'],
        correctIndex: 2,
      ),
    ],
    'entertainment': [
      QuestionModel(
        id: 'ent_001',
        category: 'entertainment',
        rarity: QuestionRarity.common,
        text: 'Which actor played Iron Man in the Marvel Cinematic Universe?',
        options: ['Chris Evans', 'Chris Hemsworth', 'Mark Ruffalo', 'Robert Downey Jr.'],
        correctIndex: 3,
      ),
      QuestionModel(
        id: 'ent_002',
        category: 'entertainment',
        rarity: QuestionRarity.common,
        text: 'What is the highest-grossing film of all time (unadjusted for inflation)?',
        options: ['Titanic', 'Avengers: Endgame', 'Avatar', 'Star Wars: The Force Awakens'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'ent_003',
        category: 'entertainment',
        rarity: QuestionRarity.common,
        text: 'Which band released the album "Abbey Road"?',
        options: ['The Rolling Stones', 'The Beatles', 'Led Zeppelin', 'Pink Floyd'],
        correctIndex: 1,
      ),
      QuestionModel(
        id: 'ent_004',
        category: 'entertainment',
        rarity: QuestionRarity.common,
        text: 'In the TV show "Breaking Bad", what is Walter White\'s occupation at the start of the series?',
        options: ['Doctor', 'Lawyer', 'Chemistry Teacher', 'Engineer'],
        correctIndex: 2,
      ),
      QuestionModel(
        id: 'ent_005',
        category: 'entertainment',
        rarity: QuestionRarity.common,
        text: 'Which video game franchise features a plumber named Mario?',
        options: ['Sega', 'Atari', 'Sony', 'Nintendo'],
        correctIndex: 3,
      ),
    ],
  };
}
