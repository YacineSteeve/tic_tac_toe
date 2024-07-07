import 'dart:io';

enum Mark {
  X,
  O,
  empty;

  @override
  String toString() {
    return switch (this) { Mark.X => 'X', Mark.O => 'O', Mark.empty => ' ' };
  }
}

class Board {
  static const size = 3;
  final Iterable<int> _directionIterator = Iterable.generate(size);
  final _lastRowIndex = size - 1;
  Mark _winner = Mark.empty;

  final List<List<Mark>> _state = [
    for (final _ in Iterable.generate(size))
      [for (final _ in Iterable.generate(size)) Mark.empty]
  ];
  final String _rowsSeparator =
      [for (final _ in Iterable.generate(4 * size + 1)) '-'].join();

  Board();

  Mark? get winner => _winner;

  void placeMark(Mark mark, int row, int column) {
    if (column < 0 || column >= size || row < 0 || row >= size) {
      throw Error();
    }

    if (_state[row][column] != Mark.empty) {
      throw Exception('Cannot override a previous move');
    }

    _state[row][column] = mark;
  }

  bool hasWinner() {
    for (final row in _state) {
      final firstMark = row[0];

      if (firstMark == Mark.empty) continue;

      if (row.every((mark) => mark == firstMark)) {
        _winner = firstMark;
        return true;
      }
    }

    for (final i in _directionIterator) {
      final firstMark = _state[i][0];
      var everyEqualsFirst = false;

      if (firstMark == Mark.empty) continue;

      for (final j in _directionIterator) {
        if (j == _lastRowIndex) {
          everyEqualsFirst = _state[i][j] == firstMark;
        } else if (_state[i][j] != firstMark) {
          break;
        }
      }

      if (everyEqualsFirst) {
        _winner = firstMark;
        return true;
      }
    }

    final topLeftMark = _state[0][0];

    if (topLeftMark != Mark.empty) {
      for (final i in _directionIterator) {
        if (i == _lastRowIndex) {
          if (_state[_lastRowIndex][_lastRowIndex] == topLeftMark) {
            _winner = topLeftMark;
            return true;
          }
        } else if (_state[i][i] != topLeftMark) {
          break;
        }
      }
    }

    final bottomLeftMark = _state[_lastRowIndex][0];

    if (bottomLeftMark != Mark.empty) {
      for (final i in _directionIterator) {
        if (i == _lastRowIndex) {
          if (_state[_lastRowIndex][0] == bottomLeftMark) {
            _winner = bottomLeftMark;
            return true;
          }
        } else if (_state[i][size - i - 1] != bottomLeftMark) {
          break;
        }
      }
    }

    return false;
  }

  bool isFull() {
    for (final row in _state) {
      for (final mark in row) {
        if (mark == Mark.empty) return false;
      }
    }
    return true;
  }

  void display() => stdout.writeln(this);

  @override
  String toString() {
    return '$_rowsSeparator\n${_state.map((row) => '|${row.map((mark) => ' $mark ').join('|')}|').join('\n$_rowsSeparator\n')}\n$_rowsSeparator';
  }
}
