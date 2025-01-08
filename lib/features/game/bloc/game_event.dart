// Define game events
abstract class GameEvent {}

class InitializeGame extends GameEvent {
  final int gridSize;
  InitializeGame(this.gridSize);
}
class RestartGame extends GameEvent {
  final int gridSize;
  RestartGame(this.gridSize);
}

class DropPiece extends GameEvent {
  final int row;
  final int col;
  DropPiece(this.row, this.col);
}

class ExplodeBomb extends GameEvent {}