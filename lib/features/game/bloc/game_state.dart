import '../models/square.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoaded extends GameState {
  final List<List<Square>> board;
  final int discoveredBombs;
  final int remainingBombs;
  final int gridSize;
  final bool showBombAnimation; // New field to control animation visibility
  final int? animationRow;     // Row of the discovered bomb
  final int? animationCol;     // Column of the discovered bomb

  GameLoaded({
    required this.board,
    required this.discoveredBombs,
    required this.remainingBombs,
    required this.gridSize,
    this.showBombAnimation = false, // Default is no animation
    this.animationRow,
    this.animationCol,
  });
}

class BombDiscovered extends GameState {
  final List<List<Square>> board;
  final int row;
  final int col;

  BombDiscovered({
    required this.board,
    required this.row,
    required this.col,
  });
}


class BombExploded extends GameState {
  final List<List<Square>> board;
  final int row;
  final int col;

  BombExploded({
    required this.board,
    required this.row,
    required this.col,
  });
}

class GameOver extends GameState {
  final int discoveredBombs;
  GameOver(this.discoveredBombs);
}