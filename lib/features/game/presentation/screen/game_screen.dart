import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:reversed_minesweeper/features/game/presentation/widgets/grid_board.dart';
import '../../bloc/game_bloc.dart';
import '../../bloc/game_event.dart';
import '../../bloc/game_state.dart';
import '../widgets/game_appbar_widget.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/gameover.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc()..add(InitializeGame(10)), // Initialize GameBloc
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: GameAppBar(
              currentGridSize: 10,
              onGridSizeSelected: (selectedGridSize) {
                context.read<GameBloc>().add(InitializeGame(selectedGridSize));
              },
            ),
            body: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey.shade800, Colors.grey.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Game content
                BlocConsumer<GameBloc, GameState>(
                  listener: (context, state) {
                    if (state is BombExploded) {
                      _playExplosionSound();
                    }
                  },
                  builder: (context, state) {
                    if (state is GameInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is GameLoaded) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              // Floating bomb counter
                              Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.whatshot, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Discovered Bombs: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset(0, 1),
                                            end: Offset(0, 0),
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                      child: Text(
                                        "${state.discoveredBombs}",
                                        key: ValueKey<int>(state.discoveredBombs),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Game board
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade800,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: GameBoard(state: state),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Lottie animation for bomb discovery
                          if (state.showBombAnimation)
                            Positioned.fill(
                              child: IgnorePointer(
                                ignoring: true, // Ensure animation doesn't block user actions
                                child: Lottie.asset(
                                  'assets/animation/success.json',
                                  repeat: false, // Play once
                                  fit: BoxFit.fill, // Covers the game board
                                ),
                              ),
                            ),
                        ],
                      );
                    } else if (state is GameOver) {
                      return GameOverWidget(
                        discoveredBombs: state.discoveredBombs,
                        onPlayAgain: () {
                          print('"Itsssssssssssssssssss Clickeddddddddddddddddd"');
                          context.read<GameBloc>().add(RestartGame(10)); // Restart game with grid size 10
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  /// Plays the explosion sound when a bomb explodes or is discovered
  Future<void> _playExplosionSound() async {
    try {
      final audioPlayer = AudioPlayer();
      await audioPlayer.play(AssetSource('sound/explosion.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }
}
