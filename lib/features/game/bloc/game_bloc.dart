import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/square.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  // Constants and initializations
  static const int totalBombs = 20;
  List<List<Square>> board = [];
  int discoveredBombs = 0;
  int remainingBombs = totalBombs;
  Timer? bombTimer;

  GameBloc() : super(GameInitial()) {
    // Register event handlers
    on<InitializeGame>(_onInitializeGame);
    on<DropPiece>(_onDropPiece);
    on<ExplodeBomb>(_onExplodeBomb);
    on<RestartGame>(_onRestartGame);
  }

  /// Handles the InitializeGame event.
  /// Sets up the game board and starts a periodic timer for bomb explosions.
  void _onInitializeGame(InitializeGame event, Emitter<GameState> emit) {
    print("Initializing game with grid size: ${event.gridSize}");
    emit(GameInitial()); // Emit initial state to clear any previous data

    // Reset game variables
    discoveredBombs = 0;
    remainingBombs = totalBombs;
    board.clear(); // Clear the previous board

    // Initialize the board
    _initializeBoard(event.gridSize);

    // Emit the new game state
    emit(GameLoaded(
      board: _cloneBoard(board),
      discoveredBombs: discoveredBombs,
      remainingBombs: remainingBombs,
      gridSize: event.gridSize,
    ));

    // Restart the timer
    bombTimer?.cancel();
    bombTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      add(ExplodeBomb());
    });
  }

  /// Handles the RestartGame event.
  /// Clears the game state and reinitializes the board.
  void _onRestartGame(RestartGame event, Emitter<GameState> emit) {
    print("Restarting game with grid size: ${event.gridSize}");

    // Emit GameInitial state to reset the UI
    emit(GameInitial());

    // Re-initialize the game
    add(InitializeGame(event.gridSize));
  }

  /// Handles the DropPiece event.
  /// Places a piece on the board and processes bomb discovery logic.
  void _onDropPiece(DropPiece event, Emitter<GameState> emit) {
    if (board[event.row][event.col].hasPiece) {
      print("Square already occupied, returning piece to original position.");
      return;
    }

    // Place the piece on the square
    board[event.row][event.col].hasPiece = true;

    // If the square has a bomb, handle discovery
    if (board[event.row][event.col].hasBomb) {
      print("Bomb discovered at row=${event.row}, col=${event.col}");
      board[event.row][event.col].bombDiscovered = true; // Mark bomb as discovered
      board[event.row][event.col].hasBomb = false;       // Remove the bomb
      discoveredBombs++;
      remainingBombs--;

      // Emit GameLoaded state with animation flag
      emit(GameLoaded(
        board: _cloneBoard(board),
        discoveredBombs: discoveredBombs,
        remainingBombs: remainingBombs,
        gridSize: board.length,
        showBombAnimation: true,
        animationRow: event.row,
        animationCol: event.col,
      ));

      // Emit the same state without animation after a delay
      Future.delayed(Duration(seconds: 2), () {
        emit(GameLoaded(
          board: _cloneBoard(board),
          discoveredBombs: discoveredBombs,
          remainingBombs: remainingBombs,
          gridSize: board.length,
        ));
      });
    } else {
      // Emit updated state for non-bomb square
      emit(GameLoaded(
        board: _cloneBoard(board),
        discoveredBombs: discoveredBombs,
        remainingBombs: remainingBombs,
        gridSize: board.length,
      ));
    }

    // Check if the game is over
    _checkGameOver(emit);
  }

  /// Handles the ExplodeBomb event.
  /// Randomly explodes one of the remaining bombs on the board.
  void _onExplodeBomb(ExplodeBomb event, Emitter<GameState> emit) {
    print("ExplodeBomb event triggered");

    // Check if there are any bombs left to explode
    if (remainingBombs > 0) {
      // Find all squares containing bombs
      var bombSquares = board.expand((row) => row).where((square) => square.hasBomb).toList();

      if (bombSquares.isNotEmpty) {
        // Randomly select a bomb to explode
        var randomSquare = bombSquares[Random().nextInt(bombSquares.length)];
        print("Bomb exploded at row=${randomSquare.row}, col=${randomSquare.col}");

        // Mark the bomb as exploded
        randomSquare.hasBomb = false;
        randomSquare.bombDiscovered = true;

        remainingBombs--; // Decrease remaining bombs

        // Emit BombExploded state for UI effects (e.g., sound)
        emit(BombExploded(
          board: _cloneBoard(board),
          row: randomSquare.row,
          col: randomSquare.col,
        ));

        // Emit updated game state
        emit(GameLoaded(
          board: _cloneBoard(board),
          discoveredBombs: discoveredBombs,
          remainingBombs: remainingBombs,
          gridSize: board.length,
        ));

        // Check if all bombs are handled
        _checkGameOver(emit);
      }
    }
  }

  /// Initializes the board with bombs and pieces.
  void _initializeBoard(int gridSize) {
    board = List.generate(
      gridSize,
          (row) => List.generate(gridSize, (col) => Square(row: row, col: col)),
    );

    int bombsPlaced = 0;
    int totalPieces = (gridSize * gridSize) ~/ 2;

    // Place bombs randomly on the board
    while (bombsPlaced < totalBombs) {
      int randomRow = Random().nextInt(gridSize);
      int randomCol = Random().nextInt(gridSize);

      if (!board[randomRow][randomCol].hasBomb) {
        board[randomRow][randomCol].hasBomb = true;
        bombsPlaced++;
        print("Bomb placed at row=$randomRow, col=$randomCol");
      }
    }

    int piecesPlaced = 0;

    // Place pieces randomly on the board (avoiding bombs)
    while (piecesPlaced < totalPieces) {
      int randomRow = Random().nextInt(gridSize);
      int randomCol = Random().nextInt(gridSize);

      if (!board[randomRow][randomCol].hasBomb && !board[randomRow][randomCol].hasPiece) {
        board[randomRow][randomCol].hasPiece = true;
        piecesPlaced++;
        print("Piece placed at row=$randomRow, col=$randomCol");
      }
    }
  }

  /// Checks if the game is over (all bombs are discovered or exploded).
  void _checkGameOver(Emitter<GameState> emit) {
    if (remainingBombs == 0) {
      print("Game over! All bombs discovered.");
      bombTimer?.cancel(); // Stop the periodic bomb timer
      emit(GameOver(discoveredBombs));
    }
  }

  /// Clones the board to ensure immutability when emitting states.
  List<List<Square>> _cloneBoard(List<List<Square>> board) {
    return List.generate(
      board.length,
          (row) => List.generate(
        board[row].length,
            (col) => Square(
          row: board[row][col].row,
          col: board[row][col].col,
          hasBomb: board[row][col].hasBomb,
          bombDiscovered: board[row][col].bombDiscovered,
          hasPiece: board[row][col].hasPiece,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    bombTimer?.cancel(); // Cancel the timer when the bloc is closed
    return super.close();
  }
}
