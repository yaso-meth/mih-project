class BoardSquare {
  bool hasBomb;
  int bombsAround;
  bool isOpened;
  bool isFlagged;

  BoardSquare({
    this.hasBomb = false,
    this.bombsAround = 0,
    this.isOpened = false,
    this.isFlagged = false,
  });
}
