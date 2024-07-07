import 'dart:io';

import 'package:args/args.dart';
import 'package:tic_tac_toe/src/game.dart';

import 'src/database/database.dart';

final playerOneArgKey = 'player-one';
final playerTwoArgKey = 'player-two';

ArgResults parseArguments(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(playerOneArgKey, mandatory: true)
    ..addOption(playerTwoArgKey, mandatory: false);

  try {
    return parser.parse(arguments);
  } on FormatException catch (exception) {
    stderr.writeln(exception.message);
    exit(2);
  }
}

void main(List<String> arguments) {
  final parsedArgs = parseArguments(arguments);

  final playerOneName = parsedArgs[playerOneArgKey];
  final playerTwoName = parsedArgs[playerTwoArgKey];

  final db = Database();

  final existingPlayerOne = db.players.find(playerOneName);
  final existingPlayerTwo = db.players.find(playerTwoName);

  final playerOne =
      existingPlayerOne ?? db.players.create({'name': playerOneName});
  final playerTwo =
      existingPlayerTwo ?? db.players.create({'name': playerTwoName});

  final match = db.matches.create(
      {'playerOneName': playerOne.name, 'playerTwoName': playerTwo.name});

  Game(playerOne: playerOne, playerTwo: playerTwo, match: match).play();

  if (existingPlayerOne == null) db.players.save(playerOne);
  if (existingPlayerTwo == null) db.players.save(playerTwo);

  db.matches.save(match);

  return;
}
