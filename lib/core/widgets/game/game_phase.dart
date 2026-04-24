/// Shared phase enum used by all trivia game modes (Daily, Survival, Rush).
///
/// Each mode has its own mode-specific phase enum (e.g. [SurvivalPhase]) that
/// maps 1:1 to [GamePhase] when interacting with shared UI widgets
/// ([AnswerOptionTile], [QuestionCard], [CountdownTimer]).
enum GamePhase { loading, answering, showingFeedback, finished }
