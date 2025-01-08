import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../bloc/game_bloc.dart';
import '../../bloc/game_event.dart';
import '../../bloc/game_state.dart';
import '../../models/square.dart';

class GameBoard extends StatelessWidget {
  final GameLoaded state;
  final AudioPlayer audioPlayer = AudioPlayer();

  GameBoard({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: _buildGridDelegate(state.gridSize),
      itemCount: state.gridSize * state.gridSize,
      itemBuilder: (context, index) {
        int row = index ~/ state.gridSize;
        int col = index % state.gridSize;
        Square square = state.board[row][col];

        return _buildSquare(context, square, row, col);
      },
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(int gridSize) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: gridSize,
    );
  }

  Widget _buildSquare(BuildContext context, Square square, int row, int col) {
    return DragTarget<Map<String, int>>(
      onWillAccept: (data) => _canAcceptDrop(square),
      onAccept: (data) => _handleDrop(context, square, row, col, data),
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: square.bombDiscovered ? null : () => _handleTap(context, square, row, col),
          child: _buildSquareContent(square, row, col),
        );
      },
    );
  }

  bool _canAcceptDrop(Square square) {
    return !square.hasPiece || square.hasBomb;
  }

  void _handleDrop(BuildContext context, Square square, int row, int col, Map<String, int> data) {
    if (square.hasBomb && !square.bombDiscovered) {
      _playExplosionSound();
    }
    context.read<GameBloc>().add(DropPiece(data['row']!, data['col']!));
    if (square.hasBomb) {
      context.read<GameBloc>().add(DropPiece(row, col));
    }
  }

  void _handleTap(BuildContext context, Square square, int row, int col) {
    if (square.hasBomb && !square.bombDiscovered) {
      _playExplosionSound();
    }
    print('Cell tapped: Row $row, Col $col');
    context.read<GameBloc>().add(DropPiece(row, col));
  }

  Widget _buildSquareContent(Square square, int row, int col) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: _buildSquareDecoration(square),
      child: _buildSquareChild(square, row, col),
    );
  }

  BoxDecoration _buildSquareDecoration(Square square) {
    return BoxDecoration(
      color: square.bombDiscovered
          ? Colors.red // Bomb exploded or discovered
          : square.hasPiece
          ? Colors.blue // Piece placed
          : Colors.grey, // Empty square
      border: Border.all(color: Colors.black),
    );
  }

  Widget _buildSquareChild(Square square, int row, int col) {
    if (square.hasPiece) {
      return Draggable<Map<String, int>>(
        data: {'row': row, 'col': col},
        feedback: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
          ),
        ),
        childWhenDragging: Container(
          color: Colors.grey, // Show empty during dragging
        ),
        onDragCompleted: () {
          // Drag was successful, no action needed here
        },
        onDraggableCanceled: (_, __) {
          // Drag failed, reset the position
          print('Piece returned to original position.');
        },
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue, // Matches the piece
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      );
    } else if (square.bombDiscovered) {
      return Center(
        child: Icon(Icons.whatshot, color: Colors.yellow), // Bomb
      );
    } else {
      return SizedBox.shrink(); // Empty square
    }
  }

  /// Plays the explosion sound
  Future<void> _playExplosionSound() async {
    try {
      await audioPlayer.play(AssetSource('sound/explosion.mp3'));
      print("Sound is playing.........");
    } catch (e) {
      print('Error playing explosion sound: $e');
    }
  }
}
