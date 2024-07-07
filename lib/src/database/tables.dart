import 'dart:io';

import 'package:tic_tac_toe/src/entities/match.dart';
import 'package:tic_tac_toe/src/entities/player.dart';

sealed class Table<T> {
  abstract final String _dataFilePath;
  late final File _dataFile;
  final List<T> _data = [];
  int _count = 0;
  abstract final T Function(Map<String, String>) jsonConstructor;

  String get name;
  List<String> get columns;

  List<T> get all => _data;
  int get count => _count;

  T create(Map<String, dynamic> params);

  List<Map<String, String>> _parseData();
  String _getTableEntry(T entity);

  void init() {
    _initDataFile();
    _initData();
  }

  void save(T entity) {
    _dataFile.writeAsStringSync('${_getTableEntry(entity)}\n',
        mode: FileMode.append);
  }

  void reset() {
    final headLine = _dataFile.readAsLinesSync().first;
    _dataFile.writeAsStringSync(headLine, mode: FileMode.writeOnly);
  }

  void _initDataFile() {
    _dataFile = File(_dataFilePath);

    if (!_dataFile.existsSync()) {
      _dataFile.createSync(recursive: true);
      _dataFile.writeAsStringSync('${columns.join(',')}\n');
    }
  }

  void _initData() {
    final entitiesData = _parseData();

    for (final entityData in entitiesData) {
      _data.add(jsonConstructor(entityData));
      _count++;
    }
  }

  @override
  String toString() {
    return '$name:\n$_data';
  }
}

final class PlayersTable extends Table<Player> {
  @override
  final _dataFilePath = './database/players.csv';

  PlayersTable();

  @override
  String get name => 'Players';

  @override
  List<String> get columns => ['ID', 'Name', 'Created At'];

  @override
  final Player Function(Map<String, String>) jsonConstructor = Player.fromJson;

  @override
  Player create(Map<String, dynamic> params) {
    if (params case {'name': String name}) {
      if (_data.any((player) => player.name == name)) {
        throw Exception('Player $name already exists');
      }

      final player = Player(id: ++_count, name: name);
      _data.add(player);
      return player;
    }

    throw FormatException('Invalid params');
  }

  @override
  List<Map<String, String>> _parseData() {
    final List<Map<String, String>> playersData = [];
    var lineCount = 0;

    for (final line in _dataFile.readAsLinesSync()) {
      lineCount++;

      switch (line.split(',')) {
        case ['ID', 'Name', 'Created At']:
          break;
        case (List<String> parts)
            when lineCount > 1 && parts.length == columns.length:
          playersData
              .add({'id': parts[0], 'name': parts[1], 'created_at': parts[2]});
          break;
        case _:
          throw FormatException(
              'Invalid CSV file at $_dataFilePath:$lineCount');
      }
    }

    return playersData;
  }

  @override
  String _getTableEntry(Player entity) {
    return '${entity.id},${entity.name},${entity.createdAt}';
  }

  Player? find(String name) {
    try {
      return _data.firstWhere((player) => player.name == name);
    } on StateError {
      return null;
    }
  }
}

final class MatchesTable extends Table<Match> {
  @override
  final _dataFilePath = './database/matches.csv';

  MatchesTable();

  @override
  String get name => 'Matches';

  @override
  List<String> get columns => [
        'ID',
        'Player One Name',
        'Player One Score',
        'Player Two Name',
        'Player Two Score',
        'Created At'
      ];

  @override
  final Match Function(Map<String, String>) jsonConstructor = Match.fromJson;

  @override
  Match create(Map<String, dynamic> params) {
    if (params
        case {
          'playerOneName': String playerOneName,
          'playerTwoName': String playerTwoName
        }) {
      final match = Match(
          id: ++_count,
          playerOneName: playerOneName,
          playerTwoName: playerTwoName);
      _data.add(match);
      return match;
    }

    throw FormatException('Invalid params');
  }

  @override
  List<Map<String, String>> _parseData() {
    final List<Map<String, String>> matchesData = [];
    var lineCount = 0;

    for (final line in _dataFile.readAsLinesSync()) {
      lineCount++;

      switch (line.trim().split(',')) {
        case [
            'ID',
            'Player One Name',
            'Player One Score',
            'Player Two Name',
            'Player Two Score',
            'Created At'
          ]:
          break;
        case (List<String> parts)
            when lineCount > 1 && parts.length == columns.length:
          matchesData.add({
            'id': parts[0],
            'player_one_name': parts[1],
            'player_one_score': parts[2],
            'player_two_name': parts[3],
            'player_two_score': parts[4],
            'created_at': parts[5]
          });
          break;
        case _:
          throw FormatException(
              'Invalid CSV file at $_dataFilePath:$lineCount');
      }
    }

    return matchesData;
  }

  @override
  String _getTableEntry(Match entity) {
    return '${entity.id},${entity.playerOne.name},${entity.playerOne.score},${entity.playerTwo.name},${entity.playerTwo.score},${entity.createdAt}';
  }
}
