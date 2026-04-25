import '../../models/knowledge_card_model.dart';

/// Static mock knowledge cards — simulates cards the user has already earned.
class MockCardService {
  MockCardService._();

  static final List<KnowledgeCardModel> allCards = [
    // ── Science ──────────────────────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_sci_001',
      category: 'science',
      rarity: CardRarity.common,
      question: 'What is the chemical symbol for gold?',
      answer: 'Au',
      earnedAt: DateTime(2026, 4, 14),
    ),
    KnowledgeCardModel(
      id: 'kc_sci_002',
      category: 'science',
      rarity: CardRarity.uncommon,
      question: 'How many bones are in the adult human body?',
      answer: '206',
      earnedAt: DateTime(2026, 4, 13),
    ),
    KnowledgeCardModel(
      id: 'kc_sci_003',
      category: 'science',
      rarity: CardRarity.common,
      question: 'What planet is known as the Red Planet?',
      answer: 'Mars',
      earnedAt: DateTime(2026, 4, 12),
    ),
    KnowledgeCardModel(
      id: 'kc_sci_004',
      category: 'science',
      rarity: CardRarity.rare,
      question: 'What gas do plants absorb during photosynthesis?',
      answer: 'Carbon dioxide',
      earnedAt: DateTime(2026, 4, 10),
    ),
    KnowledgeCardModel(
      id: 'kc_sci_005',
      category: 'science',
      rarity: CardRarity.common,
      question: 'What is the speed of light in a vacuum?',
      answer: '300,000 km/s',
      earnedAt: DateTime(2026, 4, 8),
    ),

    // ── Geography ────────────────────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_geo_001',
      category: 'geography',
      rarity: CardRarity.common,
      question: 'What is the largest country in the world by area?',
      answer: 'Russia',
      earnedAt: DateTime(2026, 4, 14),
    ),
    KnowledgeCardModel(
      id: 'kc_geo_002',
      category: 'geography',
      rarity: CardRarity.common,
      question: 'Which river is the longest in the world?',
      answer: 'The Nile',
      earnedAt: DateTime(2026, 4, 11),
    ),
    KnowledgeCardModel(
      id: 'kc_geo_003',
      category: 'geography',
      rarity: CardRarity.uncommon,
      question: 'What is the capital city of Australia?',
      answer: 'Canberra',
      earnedAt: DateTime(2026, 4, 9),
    ),
    KnowledgeCardModel(
      id: 'kc_geo_004',
      category: 'geography',
      rarity: CardRarity.legendary,
      question: 'On which continent is the Sahara Desert?',
      answer: 'Africa',
      earnedAt: DateTime(2026, 4, 7),
    ),

    // ── History ──────────────────────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_his_001',
      category: 'history',
      rarity: CardRarity.common,
      question: 'In which year did World War II end?',
      answer: '1945',
      earnedAt: DateTime(2026, 4, 15),
    ),
    KnowledgeCardModel(
      id: 'kc_his_002',
      category: 'history',
      rarity: CardRarity.common,
      question: 'Who was the first President of the United States?',
      answer: 'George Washington',
      earnedAt: DateTime(2026, 4, 13),
    ),
    KnowledgeCardModel(
      id: 'kc_his_003',
      category: 'history',
      rarity: CardRarity.rare,
      question: 'How many hills was ancient Rome built on?',
      answer: 'Seven',
      earnedAt: DateTime(2026, 4, 10),
    ),
    KnowledgeCardModel(
      id: 'kc_his_004',
      category: 'history',
      rarity: CardRarity.common,
      question: 'In which year did the Berlin Wall fall?',
      answer: '1989',
      earnedAt: DateTime(2026, 4, 6),
    ),

    // ── Sport ─────────────────────────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_spt_001',
      category: 'sport',
      rarity: CardRarity.common,
      question: 'How many players are on a soccer team on the field?',
      answer: '11',
      earnedAt: DateTime(2026, 4, 14),
    ),
    KnowledgeCardModel(
      id: 'kc_spt_002',
      category: 'sport',
      rarity: CardRarity.uncommon,
      question: 'In tennis, what is the term for a score of zero?',
      answer: 'Love',
      earnedAt: DateTime(2026, 4, 12),
    ),
    KnowledgeCardModel(
      id: 'kc_spt_003',
      category: 'sport',
      rarity: CardRarity.common,
      question: 'How many holes in a standard round of golf?',
      answer: '18',
      earnedAt: DateTime(2026, 4, 9),
    ),

    // ── Entertainment ─────────────────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_ent_001',
      category: 'entertainment',
      rarity: CardRarity.common,
      question: 'Which actor played Iron Man in the MCU?',
      answer: 'Robert Downey Jr.',
      earnedAt: DateTime(2026, 4, 15),
    ),
    KnowledgeCardModel(
      id: 'kc_ent_002',
      category: 'entertainment',
      rarity: CardRarity.rare,
      question: 'What is the highest-grossing film of all time (not adjusted)?',
      answer: 'Avatar (2009)',
      earnedAt: DateTime(2026, 4, 11),
    ),
    KnowledgeCardModel(
      id: 'kc_ent_003',
      category: 'entertainment',
      rarity: CardRarity.unique,
      question: 'Who composed the "Four Seasons" violin concertos?',
      answer: 'Antonio Vivaldi',
      earnedAt: DateTime(2026, 4, 8),
    ),

    // ── Events (Japanese Anime) ───────────────────────────────────────────────
    KnowledgeCardModel(
      id: 'kc_evt_001',
      category: 'events',
      rarity: CardRarity.rare,
      question: 'What is the name of the main character in Naruto?',
      answer: 'Naruto Uzumaki',
      earnedAt: DateTime(2026, 4, 16),
    ),
    KnowledgeCardModel(
      id: 'kc_evt_002',
      category: 'events',
      rarity: CardRarity.uncommon,
      question: 'In Attack on Titan, what is the organization that fights Titans outside the walls?',
      answer: 'Survey Corps',
      earnedAt: DateTime(2026, 4, 16),
    ),
    KnowledgeCardModel(
      id: 'kc_evt_003',
      category: 'events',
      rarity: CardRarity.legendary,
      question: 'Which anime features a notebook that kills anyone whose name is written in it?',
      answer: 'Death Note',
      earnedAt: DateTime(2026, 4, 17),
    ),
    KnowledgeCardModel(
      id: 'kc_evt_004',
      category: 'events',
      rarity: CardRarity.unique,
      question: 'In Dragon Ball Z, what is the name of Goku\'s most powerful Super Saiyan transformation introduced in Battle of Gods?',
      answer: 'Super Saiyan God',
      earnedAt: DateTime(2026, 4, 17),
    ),
  ];
}
