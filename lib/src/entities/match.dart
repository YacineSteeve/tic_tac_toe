final class MatchPlayer {
  final String _name;
  int _score;

  MatchPlayer({required String name, int? score})
      : _name = name,
        _score = score ?? 0;

  String get name => _name;
  int get score => _score;

  set score(int value) {
    if (value < 0) {
      throw Exception('Score must be greater than 0');
    }

    _score = value;
  }

  @override
  String toString() {
    return '$_name($_score)';
  }

  @override
  bool operator ==(Object other) {
    return other is MatchPlayer && _name == other._name;
  }

  @override
  int get hashCode => _name.hashCode;
}

class Match {
  final int _id;
  final MatchPlayer _playerOne;
  final MatchPlayer _playerTwo;
  final DateTime _createdAt;

  Match(
      {required int id,
      required String playerOneName,
      required String playerTwoName,
      int? playerOneScore,
      int? playerTwoScore,
      DateTime? createdAt})
      : _id = id,
        _playerOne = MatchPlayer(name: playerOneName, score: playerOneScore),
        _playerTwo = MatchPlayer(name: playerTwoName, score: playerTwoScore),
        _createdAt = createdAt ?? DateTime.now();

  factory Match.fromJson(Map<String, String> json) {
    return switch (json) {
      {
        'id': String id,
        'player_one_name': String playerOneName,
        'player_one_score': String playerOneScore,
        'player_two_name': String playerTwoName,
        'player_two_score': String playerTwoScore,
        'created_at': String createdAt
      } =>
        Match(
            id: int.parse(id),
            playerOneName: playerOneName,
            playerTwoName: playerTwoName,
            playerOneScore: int.parse(playerOneScore),
            playerTwoScore: int.parse(playerTwoScore),
            createdAt: DateTime.parse(createdAt)),
      _ => throw FormatException('Invalid JSON format for Match')
    };
  }

  int get id => _id;
  MatchPlayer get playerOne => _playerOne;
  MatchPlayer get playerTwo => _playerTwo;
  DateTime get createdAt => _createdAt;

  @override
  String toString() {
    return '$playerOne vs $playerTwo';
  }

  @override
  bool operator ==(Object other) {
    return other is Match && _id == other._id;
  }

  @override
  int get hashCode => _id;
}
