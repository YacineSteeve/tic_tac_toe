import 'package:tic_tac_toe/src/database/tables.dart';

class Database {
  final Map<String, Table> _tables;

  Database()
      : _tables = {
          'players': PlayersTable()..init(),
          'matches': MatchesTable()..init()
        };

  get tables => _tables.keys;

  PlayersTable get players => _getTable('players');
  MatchesTable get matches => _getTable('matches');

  T _getTable<T extends Table>(String tableName) {
    final table = _tables[tableName];

    if (table == null) {
      throw Error();
    }

    return table as T;
  }

  void clear() {
    for (final table in _tables.values) {
      table.reset();
    }
  }
}
