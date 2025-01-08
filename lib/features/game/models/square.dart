class Square {
  final int row;
  final int col;
  bool hasBomb;
  bool bombDiscovered;
  bool hasPiece;

  Square({
    required this.row,
    required this.col,
    this.hasBomb = false,
    this.bombDiscovered = false,
    this.hasPiece = false,
  });

  // Add the copy method
  Square copy() {
    return Square(
      row: row,
      col: col,
      hasBomb: hasBomb,
      bombDiscovered: bombDiscovered,
      hasPiece: hasPiece,
    );
  }
}
