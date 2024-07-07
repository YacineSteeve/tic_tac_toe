import 'dart:io';

import 'package:tic_tac_toe/src/board.dart';
import 'package:tic_tac_toe/src/entities/match.dart';
import 'package:tic_tac_toe/src/entities/player.dart';

class Game {
  final Board _board;
  final Match _match;
  final Map<Mark, Player> _players;
  Mark _turn = Mark.empty;
  final Mark _firstPlayer = Mark.X;
  final _maxBoardPosition = Board.size * Board.size;

  Game({required Player playerOne, required Player playerTwo, required match})
      : _board = Board(),
        _match = match,
        _players = {Mark.X: playerOne, Mark.O: playerTwo};

  void play() {
    var hasWinner = false;
    var isBoardFull = false;
    _turn = _firstPlayer;

    while (!isBoardFull && !hasWinner) {
      final playerMove = _getPlayerMove();

      _board.placeMark(_turn, playerMove.row, playerMove.column);
      _board.display();
      _toggleTurn();

      hasWinner = _board.hasWinner();
      isBoardFull = _board.isFull();
    }

    final potentialWinner = _players[_board.winner];

    _announceResult(potentialWinner);
    _registerResult(potentialWinner);
  }

  ({int row, int column}) _getPlayerMove() {
    var move = int.tryParse(
        _prompt('${_players[_turn]?.name ?? 'Nobody'}\'s move : '));

    while (move == null || move < 0 || move > _maxBoardPosition) {
      move = int.tryParse(_prompt('You must type an integer from 1 to 9 : '));
    }

    return (row: (move - 1) ~/ Board.size, column: (move - 1) % Board.size);
  }

  String _prompt(String? message) {
    stdout.write(message);
    return stdin.readLineSync() ?? '';
  }

  void _toggleTurn() {
    _turn = switch (_turn) {
      Mark.X => Mark.O,
      Mark.O => Mark.X,
      Mark.empty => _firstPlayer
    };
  }

  void _announceResult(Player? potentialWinner) {
    stdout.writeln(potentialWinner == null
        ? 'It\'s a draw!'
        : 'And the winner is... ${potentialWinner.name} !');
  }

  void _registerResult(Player? potentialWinner) {
    if (potentialWinner == null) return;

    if (potentialWinner.name == _match.playerOne.name) {
      _match.playerOne.score++;
      return;
    }

    if (potentialWinner.name == _match.playerTwo.name) {
      _match.playerTwo.score++;
      return;
    }
  }

  @override
  String toString() {
    return _board.toString();
  }
}
